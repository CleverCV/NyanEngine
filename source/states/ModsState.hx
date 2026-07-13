package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class ModsState extends FlxState
{
    override public function create():Void
    {
        super.create();
        FlxG.mouse.visible = true;

        var t = new FlxText(0, FlxG.height/2 - 10, FlxG.width, "Mods - TODO");
        t.setFormat(null, 16, 0xFFFFFFFF, "center");
        add(t);
    }
}
