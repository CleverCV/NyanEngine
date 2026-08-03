package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.utils.Assets as OpenFlAssets;

class Countdown extends FlxSpriteGroup
{
    public var onComplete:Void->Void;
    
    private var countTimer:Float = 0;
    private var currentStep:Int = 0;
    private var isRunning:Bool = false;

    public function new()
    {
        super();
    }

    public function start():Void
    {
        currentStep = 0;
        isRunning = true;
        countTimer = 0;
        nextStep();
    }

    private function nextStep():Void
    {
        switch (currentStep)
        {
            case 0:
                // "Three" / 3
                playSound("assets/shared/sounds/intro3.ogg");

            case 1:
                // "Two" / Ready
                showSprite("assets/shared/images/ready.png");
                playSound("assets/shared/sounds/intro2.ogg");

            case 2:
                // "One" / Set
                showSprite("assets/shared/images/set.png");
                playSound("assets/shared/sounds/intro1.ogg");

            case 3:
                // "Go!"
                showSprite("assets/shared/images/go.png");
                playSound("assets/shared/sounds/introGo.ogg");

            case 4:
                isRunning = false;
                if (onComplete != null)
                    onComplete();
        }
        currentStep++;
    }

    private function playSound(path:String):Void
    {
        #if sys
        if (sys.FileSystem.exists(path))
        {
            FlxG.sound.play(openfl.media.Sound.fromFile(path));
            return;
        }
        #end

        if (OpenFlAssets.exists(path))
        {
            FlxG.sound.play(path);
        }
        else
        {
            trace("No se encontró el audio en: " + path);
        }
    }

    private function showSprite(path:String):Void
    {
        #if sys
        if (sys.FileSystem.exists(path))
        {
            var spr = new FlxSprite().loadGraphic(path);
            spr.screenCenter();
            spr.antialiasing = true;
            add(spr);

            flixel.tweens.FlxTween.tween(spr, {alpha: 0}, 0.6, {
                onComplete: function(twn) {
                    remove(spr, true);
                    spr.destroy();
                }
            });
            return;
        }
        #end

        if (OpenFlAssets.exists(path))
        {
            var spr = new FlxSprite().loadGraphic(path);
            spr.screenCenter();
            spr.antialiasing = true;
            add(spr);

            flixel.tweens.FlxTween.tween(spr, {alpha: 0}, 0.6, {
                onComplete: function(twn) {
                    remove(spr, true);
                    spr.destroy();
                }
            });
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (isRunning)
        {
            countTimer += elapsed;
            if (countTimer >= 0.6)
            {
                countTimer = 0;
                nextStep();
            }
        }
    }
}