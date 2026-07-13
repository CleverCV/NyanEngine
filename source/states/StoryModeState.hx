package states;

import flixel.FlxState;
import flixel.text.FlxText;

class StoryModeState extends FlxState
{
    override public function create():Void
    {
        super.create();

        // Create simple text to show you are here
        var text = new FlxText(0, 0, 0, "YOU ARE ON THE STORY MODE STATE", 32);
        text.screenCenter(); // Centers it on screen
        add(text);
    }
}