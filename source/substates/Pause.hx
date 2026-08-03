package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.FreePlayState;
import states.PsychPlayState;
import utils.Alphabet;

class Pause extends FlxSubState
{
    var grpMenuShit:FlxTypedGroup<Alphabet>;
    var menuItems:Array<String> = ['RESUME', 'RESTART', 'EXIT'];
    var curSelected:Int = 0;

    var bg:FlxSprite;

    public function new()
    {
        super();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0.6;
        add(bg);

        grpMenuShit = new FlxTypedGroup<Alphabet>();
        add(grpMenuShit);

        for (i in 0...menuItems.length)
        {
            var item:Alphabet = new Alphabet(80, 200 + (i * 120), menuItems[i], true);
            item.ID = i;
            grpMenuShit.add(item);
        }

        changeSelection(0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.anyJustPressed([UP, W]))
        {
            changeSelection(-1);
        }
        if (FlxG.keys.anyJustPressed([DOWN, S]))
        {
            changeSelection(1);
        }

        if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
        {
            var daSelected:String = menuItems[curSelected];

            switch (daSelected)
            {
                case "RESUME":
                    close(); 
                case "RESTART":
                    FlxG.resetState();
                case "EXIT":
                    FlxG.sound.music.stop();
                    FlxG.switchState(new FreePlayState());
            }
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = menuItems.length - 1;
        if (curSelected >= menuItems.length)
            curSelected = 0;

        grpMenuShit.forEach(function(item:Alphabet)
        {
            if (item.ID == curSelected)
            {
                item.color = 0xFFFFFF00; 
                item.alpha = 1.0;
                item.x = 110; 
            }
            else
            {
                item.color = 0xFFFFFFFF; 
                item.alpha = 0.6;
                item.x = 80;
            }
        });
    }
}