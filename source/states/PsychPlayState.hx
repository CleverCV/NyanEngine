package states;

import Note;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;

class PsychPlayState extends FlxState
{
    var chartData:Dynamic;
    
    var playerStrums:FlxTypedGroup<FlxSprite>;
    var enemyStrums:FlxTypedGroup<FlxSprite>;
    var grpNotes:FlxTypedGroup<Note>;

    var songTime:Float = 0;
    var scrollSpeed:Float = 2.5;

    var strumsData:Array<String> = ['arrowLEFT', 'arrowDOWN', 'arrowUP', 'arrowRIGHT'];
    var pressAnims:Array<String> = ['left press', 'down press', 'up press', 'right press'];

    public function new(parsedData:Dynamic)
    {
        super();
        this.chartData = parsedData;
        if (chartData.speed != null) scrollSpeed = chartData.speed;
    }

    override public function create():Void
    {
        super.create();

        playerStrums = new FlxTypedGroup<FlxSprite>();
        enemyStrums = new FlxTypedGroup<FlxSprite>();
        grpNotes = new FlxTypedGroup<Note>();

		// Generar Receptores (Strums)
        for (i in 0...4) {
            var enemyArrow = new FlxSprite(100 + (i * 110), 50);
            enemyArrow.frames = FlxAtlasFrames.fromSparrow("assets/shared/images/notes/NOTE_assets.png", "assets/shared/images/notes/NOTE_assets.xml");
            enemyArrow.animation.addByPrefix('static', strumsData[i] + '0');
            enemyArrow.animation.play('static');
            enemyArrow.setGraphicSize(Std.int(enemyArrow.width * 0.7));
            enemyArrow.updateHitbox();
            enemyArrow.antialiasing = true;
			// Aplicamos el shader al receptor enemigo pasando su dirección 'i'
            enemyStrums.add(enemyArrow);

            var playerArrow = new FlxSprite(700 + (i * 110), 50);
            playerArrow.frames = FlxAtlasFrames.fromSparrow("assets/shared/images/notes/NOTE_assets.png", "assets/shared/images/notes/NOTE_assets.xml");
            playerArrow.animation.addByPrefix('static', strumsData[i] + '0');
            playerArrow.animation.addByPrefix('press', pressAnims[i]);
            playerArrow.animation.play('static');
            playerArrow.setGraphicSize(Std.int(playerArrow.width * 0.7));
            playerArrow.updateHitbox();
            playerArrow.antialiasing = true;
			// Aplicamos el shader al receptor del jugador pasando su dirección 'i'
            playerStrums.add(playerArrow);
        }

        add(enemyStrums);
        add(playerStrums);
        add(grpNotes);

        loadNotesFromChart();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        songTime += elapsed * 1000;

        grpNotes.forEachAlive(function(daNote:Note) {
            var targetStrumX:Float = 0;
            if (daNote.mustHit) {
                targetStrumX = 700 + (daNote.noteData * 110);
            } else {
                targetStrumX = 100 + (daNote.noteData * 110);
            }

            var targetY:Float = 50 + ((daNote.strumTime - songTime) * (scrollSpeed * 0.45));

            daNote.x = targetStrumX;
            daNote.y = targetY;

            if (targetY < -100) {
                daNote.kill();
                grpNotes.remove(daNote, true);
            }
        });

        handleInputs();
    }

    function handleInputs():Void
    {
        var keysPressed = [FlxG.keys.anyPressed([LEFT, A]), FlxG.keys.anyPressed([DOWN, S]), FlxG.keys.anyPressed([UP, W]), FlxG.keys.anyPressed([RIGHT, D])];
        var keysJustPressed = [FlxG.keys.anyJustPressed([LEFT, A]), FlxG.keys.anyJustPressed([DOWN, S]), FlxG.keys.anyJustPressed([UP, W]), FlxG.keys.anyJustPressed([RIGHT, D])];

        for (i in 0...4)
        {
            var strum = playerStrums.members[i];

            if (keysJustPressed[i])
            {
                strum.animation.play('press', true);
                
                grpNotes.forEachAlive(function(daNote:Note) {
                    if (daNote.mustHit && daNote.noteData == i) {
                        if (Math.abs(daNote.strumTime - songTime) < 150) {
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

    function loadNotesFromChart():Void
    {
        if (chartData == null || chartData.notes == null) return;

        var sections:Array<Dynamic> = chartData.notes;

        for (section in sections)
        {
            if (section.sectionNotes == null) continue;

			var notesArray:Array<Dynamic> = section.sectionNotes;
            var sectionMustHit:Bool = section.mustHitSection; 

            for (noteData in notesArray)
            {
                var strumTime:Float = noteData[0];
                var noteType:Int = Std.int(noteData[1]);

                var actualLane:Int = noteType % 4; 

                var isPlayerNote:Bool = sectionMustHit;
                if (noteType > 3) {
                    isPlayerNote = !sectionMustHit;
                }

                var newNote = new Note(strumTime, actualLane, isPlayerNote);
                grpNotes.add(newNote);
            }
        }

		grpNotes.sort(function(order:Int, Obj1:Note, Obj2:Note):Int
		{
			if (Obj1.strumTime < Obj2.strumTime)
				return -1 * order;
			else if (Obj1.strumTime > Obj2.strumTime)
				return 1 * order;
            return 0;
		});
	}
}