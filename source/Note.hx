package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Note extends FlxSprite
{
    public var strumTime:Float = 0;
    public var noteData:Int = 0; 
    public var mustHit:Bool = false; 

    public function new(strumTime:Float, noteData:Int, mustHit:Bool)
    {
        super();
        this.strumTime = strumTime;
        this.noteData = noteData;
        this.mustHit = mustHit;

        // Path looking inside your target assets directory
        frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/notes/NOTE_assets.png", 
            "assets/shared/images/notes/NOTE_assets.xml"
        );

        // Fixed names to target your specific XML configuration
        animation.addByPrefix('purpleScroll', 'purple0'); // Targets purple0000
        animation.addByPrefix('blueScroll', 'blue0');     // Targets blue0000
        animation.addByPrefix('greenScroll', 'green0');   // Targets green0000
        animation.addByPrefix('redScroll', 'red0');       // Targets red0000

        switch (noteData)
        {
            case 0: animation.play('purpleScroll');
            case 1: animation.play('blueScroll');
            case 2: animation.play('greenScroll');
            case 3: animation.play('redScroll');
        }

        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();
        antialiasing = true;
    }
}