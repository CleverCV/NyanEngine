package states;

import Note;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;

class VSlicePlayState extends FlxState
{
	var chartData:Dynamic;

	var playerStrums:FlxTypedGroup<FlxSprite>;
	var enemyStrums:FlxTypedGroup<FlxSprite>;
	var grpNotes:FlxTypedGroup<Note>;

	var songTime:Float = 0;
	var scrollSpeed:Float = 2.8; // Velocidad base por defecto asignada por el parser VSlice

	// Mapeo de animaciones del XML
	var strumsData:Array<String> = ['arrowLEFT', 'arrowDOWN', 'arrowUP', 'arrowRIGHT'];
	var pressAnims:Array<String> = ['left press', 'down press', 'up press', 'right press'];

	public function new(parsedData:Dynamic)
	{
		super();
		this.chartData = parsedData;
		// Asignamos la velocidad si el JSON de VSlice la provee
		if (chartData.speed != null)
			scrollSpeed = chartData.speed;
	}

	override public function create():Void
	{
		super.create();

		playerStrums = new FlxTypedGroup<FlxSprite>();
		enemyStrums = new FlxTypedGroup<FlxSprite>();
		grpNotes = new FlxTypedGroup<Note>();

		// Generar Receptores (Strumline)
		for (i in 0...4)
		{
			// --- Flechas Enemigas ---
			var enemyArrow = new FlxSprite(100 + (i * 110), 50);
			enemyArrow.frames = FlxAtlasFrames.fromSparrow("assets/shared/images/notes/NOTE_assets.png", "assets/shared/images/notes/NOTE_assets.xml");
			enemyArrow.animation.addByPrefix('static', strumsData[i] + '0'); // arrowLEFT0, etc.
			enemyArrow.animation.play('static');
			enemyArrow.setGraphicSize(Std.int(enemyArrow.width * 0.7));
			enemyArrow.updateHitbox();
			enemyArrow.antialiasing = true;
			enemyStrums.add(enemyArrow);

			// --- Flechas Jugador ---
			var playerArrow = new FlxSprite(700 + (i * 110), 50);
			playerArrow.frames = FlxAtlasFrames.fromSparrow("assets/shared/images/notes/NOTE_assets.png", "assets/shared/images/notes/NOTE_assets.xml");
			playerArrow.animation.addByPrefix('static', strumsData[i] + '0');
			playerArrow.animation.addByPrefix('press', pressAnims[i]);
			playerArrow.animation.play('static');
			playerArrow.setGraphicSize(Std.int(playerArrow.width * 0.7));
			playerArrow.updateHitbox();
			playerArrow.antialiasing = true;
			playerStrums.add(playerArrow);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Avanzar el reloj interno de la canción
		songTime += elapsed * 1000;

		// Movimiento de las Flechas (Scroll)
		grpNotes.forEachAlive(function(daNote:Note)
		{
			var targetStrumX:Float = 0;
			if (daNote.mustHit)
			{
				targetStrumX = 700 + (daNote.noteData * 110);
			}
			else
			{
				targetStrumX = 100 + (daNote.noteData * 110);
			}

			// Math de scroll vertical basado en la velocidad de VSlice
			var targetY:Float = 50 + ((daNote.strumTime - songTime) * (scrollSpeed * 0.45));

			daNote.x = targetStrumX;
			daNote.y = targetY;

			// Destruir flechas fuera de la pantalla superior
			if (targetY < -100)
			{
				daNote.kill();
				grpNotes.remove(daNote, true);
			}
		});

		// Detectar teclas presionadas
		handleInputs();
	}

	function handleInputs():Void
	{
		var keysPressed = [
			FlxG.keys.anyPressed([LEFT, A]),
			FlxG.keys.anyPressed([DOWN, S]),
			FlxG.keys.anyPressed([UP, W]),
			FlxG.keys.anyPressed([RIGHT, D])
		];

		var keysJustPressed = [
			FlxG.keys.anyJustPressed([LEFT, A]),
			FlxG.keys.anyJustPressed([DOWN, S]),
			FlxG.keys.anyJustPressed([UP, W]),
			FlxG.keys.anyJustPressed([RIGHT, D])
		];

		for (i in 0...4)
		{
			var strum = playerStrums.members[i];

			if (keysJustPressed[i])
			{
				strum.animation.play('press', true);

				// Sistema simple para golpear flechas
				grpNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote.mustHit && daNote.noteData == i)
					{
						if (Math.abs(daNote.strumTime - songTime) < 150)
						{ // Ventana de 150ms
							daNote.kill();
							grpNotes.remove(daNote, true);
						}
					}
				});
			}

			if (!keysPressed[i] && strum.animation.curAnim.name == 'press')
			{
				strum.animation.play('static');
			}
		}
	}

	function generateDummyChart():Void
	{
		// Notas ficticias para probar que el gameplay y las animaciones corren bien en VSlice
		for (i in 0...40)
		{
			var time:Float = 1200 + (i * 380);
			var lane:Int = i % 4;
			var isPlayer:Bool = (i % 2 == 0);

			var testNote = new Note(time, lane, isPlayer);
			grpNotes.add(testNote);
		}
	}
}