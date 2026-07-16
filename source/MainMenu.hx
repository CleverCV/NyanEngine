package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.FreePlayState;
import states.StoryModeState;

// 1. Importamos el Virtual Pad y su estilo de botones
#if mobile
import flixel.ui.FlxVirtualPad;
#end

class MainMenu extends FlxState
{ 
    var _bg:FlxSprite;
    var _storyModeBtn:FlxSprite;
    var _freeplayBtn:FlxSprite;

	var _storyBaseX:Float = 70; // Movido un poquito a la derecha por el aumento de escala
	var _freeplayBaseX:Float = 70;

    var curSelected:Int = 0;

	var azurengv:FlxText;
	var psychparsr:FlxText;

	// 2. Declaramos la variable del control táctil solo para compilaciones móviles
	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

    override public function create():Void
    {
        super.create();

        FlxG.mouse.visible = false;

        _bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
        add(_bg);

		_storyModeBtn = new FlxSprite(_storyBaseX, 120);
        _storyModeBtn.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/mainmenu/menu_story_mode.png", 
            "assets/shared/images/mainmenu/menu_story_mode.xml"
		);
        _storyModeBtn.animation.addByPrefix("idle", "story_mode selected", 24, true);
		_storyModeBtn.animation.addByPrefix("selected", "story_mode idle", 24, true);
		_storyModeBtn.scale.set(1, 1);
		_storyModeBtn.updateHitbox();
		_storyModeBtn.antialiasing = true;
        add(_storyModeBtn);

		_freeplayBtn = new FlxSprite(_freeplayBaseX, 360); 
        _freeplayBtn.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/mainmenu/menu_freeplay.png", 
            "assets/shared/images/mainmenu/menu_freeplay.xml"
		);
        _freeplayBtn.animation.addByPrefix("idle", "freeplay selected", 24, true);
		_freeplayBtn.animation.addByPrefix("selected", "freeplay idle", 24, true);
		_freeplayBtn.scale.set(1, 1);
		_freeplayBtn.updateHitbox();
		_freeplayBtn.antialiasing = true;
        add(_freeplayBtn);

		psychparsr = new FlxText(10, FlxG.height - 54, 0, "PsychEngine Parser Indev 1.7", 16);
		psychparsr.font = "assets/fonts/vcr.ttf";
		psychparsr.color = FlxColor.WHITE;
		psychparsr.setFormat(psychparsr.font, 18, FlxColor.WHITE, LEFT);
		psychparsr.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
		psychparsr.antialiasing = true;
		add(psychparsr);

		azurengv = new FlxText(10, FlxG.height - 30, 0, "Azure Engine Indev 2.0", 16);
		azurengv.font = "assets/fonts/vcr.ttf";
		azurengv.color = FlxColor.WHITE;
		azurengv.setFormat(azurengv.font, 18, FlxColor.WHITE, LEFT);
		azurengv.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
		azurengv.antialiasing = true;
		add(azurengv);

		#if mobile
		_virtualPad = new FlxVirtualPad(flixel.ui.FlxVirtualPad.FlxDPadMode.UP_DOWN, flixel.ui.FlxVirtualPad.FlxActionMode.A_B);
		_virtualPad.alpha = 0.75;

		var touchScale:Float = 1.5;
		for (button in [
			_virtualPad.buttonUp,
			_virtualPad.buttonDown,
			_virtualPad.buttonA,
			_virtualPad.buttonB
		])
		{
			if (button != null)
			{
				button.scale.set(touchScale, touchScale);
				button.updateHitbox();
			}
		}

		_virtualPad.buttonUp.x = 40;
		_virtualPad.buttonUp.y = FlxG.height - 260;
		_virtualPad.buttonDown.x = 40;
		_virtualPad.buttonDown.y = FlxG.height - 140;

		_virtualPad.buttonB.x = FlxG.width - 140;
		_virtualPad.buttonB.y = FlxG.height - 140;
		_virtualPad.buttonA.x = FlxG.width - 260;
		_virtualPad.buttonA.y = FlxG.height - 140;

		add(_virtualPad);
		#end

        changeSelection(0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);


		var upPressed:Bool = false;
		var downPressed:Bool = false;
		var acceptPressed:Bool = false;

		#if !mobile
		upPressed = FlxG.keys.anyJustPressed([UP, W]);
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]);
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]);
		#else
		upPressed = FlxG.keys.anyJustPressed([UP, W]) || _virtualPad.buttonUp.justPressed;
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]) || _virtualPad.buttonDown.justPressed;
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]) || _virtualPad.buttonA.justPressed;
		#end

		if (upPressed)
        {
            changeSelection(-1);
        }
		if (downPressed)
        {
            changeSelection(1);
        }
		if (acceptPressed)
        {
            goToState();
		}
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = 1;
        if (curSelected > 1)
            curSelected = 0;

        if (curSelected == 0)
        {
			_storyModeBtn.x = _storyBaseX + 15;
            _storyModeBtn.animation.play("selected");
        }
        else
        {
			_storyModeBtn.x = _storyBaseX;
            _storyModeBtn.animation.play("idle");
        }

        if (curSelected == 1)
        {
			_freeplayBtn.x = _freeplayBaseX + 15;
            _freeplayBtn.animation.play("selected");
        }
        else
        {
			_freeplayBtn.x = _freeplayBaseX;
            _freeplayBtn.animation.play("idle");
        }
    }

    function goToState():Void
	{
		#if mobile
		if (_virtualPad != null)
			_virtualPad = flixel.util.FlxDestroyUtil.destroy(_virtualPad);
		#end

        if (curSelected == 0)
        {
            FlxG.switchState(new StoryModeState());
        }
        else if (curSelected == 1)
        {
            FlxG.switchState(new FreePlayState());
        }
    }
}