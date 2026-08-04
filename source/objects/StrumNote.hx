package objects;

import Note;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

/** Receptor de notas que usa el atlas compartido strums.png/.xml. */
class StrumNote extends FlxSprite
{
    private static var cachedFrames:FlxAtlasFrames;

    public function new(x:Float, y:Float, lane:Int)
    {
        super(x, y);
        if (cachedFrames == null)
        {
            cachedFrames = FlxAtlasFrames.fromSparrow(
                "assets/shared/images/notes/strums.png",
                "assets/shared/images/notes/strums.xml"
            );
        }
// mec
        frames = cachedFrames;
        antialiasing = true;

        var direction = Note.getLaneName(lane);
        animation.addByPrefix("static", "strum " + direction + " static", 24, true);
        animation.addByPrefix("press", "strum " + direction + " pressed", 24, true);
        animation.addByPrefix("confirm", "strum " + direction + " confirm", 24, false);
        animation.play("static");

        setGraphicSize(Std.int(width * 0.4), Std.int(height * 0.4));
        updateHitbox();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (animation.curAnim != null && animation.curAnim.name == "confirm" && animation.curAnim.finished)
            animation.play("static");
    }
}