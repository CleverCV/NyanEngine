package states;

import Note;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.StrumNote;

class VSlicePlayState extends FlxState
{
	var chartData:Dynamic;

	var playerStrums:FlxTypedGroup<FlxSprite>;
	var enemyStrums:FlxTypedGroup<FlxSprite>;
	var grpNotes:FlxTypedGroup<Note>;

	var songTime:Float = 0;
	var scrollSpeed:Float = 2.8;
	public function new(parsedData:Dynamic)
	{
		super();
		this.chartData = parsedData;
		if (chartData.speed != null)
			scrollSpeed = chartData.speed;
	}

	override public function create():Void
	{
		super.create();

		playerStrums = new FlxTypedGroup<FlxSprite>();
		enemyStrums = new FlxTypedGroup<FlxSprite>();
		grpNotes = new FlxTypedGroup<Note>();

		for (i in 0...4)
		{
			var enemyArrow = new StrumNote(100 + (i * 110), 50, i);
			enemyStrums.add(enemyArrow);

			var playerArrow = new StrumNote(700 + (i * 110), 50, i);
			playerStrums.add(playerArrow);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		songTime += elapsed * 1000;

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

			var targetY:Float = 50 + ((daNote.strumTime - songTime) * (scrollSpeed * 0.45));

			daNote.x = targetStrumX;
			daNote.y = targetY;

			if (targetY < -100)
			{
				daNote.kill();
				grpNotes.remove(daNote, true);
			}
		});

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

				grpNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote.mustHit && daNote.noteData == i)
					{
						if (Math.abs(daNote.strumTime - songTime) < 150)
						{ 
							strum.animation.play('confirm', true);
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