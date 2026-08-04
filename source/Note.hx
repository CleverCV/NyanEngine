package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Note extends FlxSprite
{
    private static var cachedFrames:FlxAtlasFrames;
    private static var laneNames:Array<String> = ["left", "down", "up", "right"];

    public var strumTime:Float = 0;
    public var noteData:Int = 0;
    public var mustHit:Bool = false;
    public var isSustainNote:Bool = false;
    public var parentNote:Note = null;
    public var sustainLength:Float = 0;
    public var wasPressed:Bool = false;

    public static function getLaneName(lane:Int):String
    {
        var normalized = lane % laneNames.length;
        if (normalized < 0) normalized += laneNames.length;
        return laneNames[normalized];
    }

    public function new(strumTime:Float, noteData:Int, mustHit:Bool, isSustainNote:Bool = false, isLastSustain:Bool = false)
    {
        super();
        this.strumTime = strumTime;
        this.noteData = noteData % laneNames.length;
        if (this.noteData < 0) this.noteData += laneNames.length;
        this.mustHit = mustHit;
        this.isSustainNote = isSustainNote;

        if (cachedFrames == null)
        {
            cachedFrames = FlxAtlasFrames.fromSparrow(
                "assets/shared/images/notes/notes.png",
                "assets/shared/images/notes/notes.xml"
            );
        }
        frames = cachedFrames;
        antialiasing = true;

        var direction = getLaneName(this.noteData);
        animation.addByPrefix("scroll", "note " + direction + "0", 24, false);
        animation.addByPrefix("hold", "note " + direction + " hold0", 24, false);
        animation.addByPrefix("holdEnd", "note " + direction + " hold end", 24, false);

        if (isSustainNote)
        {
            animation.play(isLastSustain ? "holdEnd" : "hold");
            alpha = 0.6;
            scale.set(0.7, 0.7);
        }
        else
        {
            animation.play("scroll");
            setGraphicSize(Std.int(width * 0.7));
        }

        updateHitbox();
    }
}