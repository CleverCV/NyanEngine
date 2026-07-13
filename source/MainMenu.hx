package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import states.FreePlayState;
import states.StoryModeState;

class MainMenu extends FlxState
{ 
    var _bg:FlxSprite;
    var _storyModeBtn:FlxSprite;
    var _freeplayBtn:FlxSprite;

    // Posiciones iniciales en X para que sepan a dónde regresar
    var _storyBaseX:Float = 50;
    var _freeplayBaseX:Float = 50;

    // Control de selección (0 = Story Mode, 1 = Freeplay)
    var curSelected:Int = 0;

    override public function create():Void
    {
        super.create();

        // Ocultamos el mouse para usar puras flechas/teclado como en Psych Engine
        FlxG.mouse.visible = false;

        // 1. Configurar el Fondo Amarillo
        _bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
        add(_bg);

        // 2. Configurar Botón de Story Mode
        _storyModeBtn = new FlxSprite(_storyBaseX, 100);
        _storyModeBtn.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/mainmenu/menu_story_mode.png", 
            "assets/shared/images/mainmenu/menu_story_mode.xml"
        );
        // Usamos los nombres invertidos tal como descubrimos para arreglar tu bug de animación
        _storyModeBtn.animation.addByPrefix("idle", "story_mode selected", 24, true);
        _storyModeBtn.animation.addByPrefix("selected", "story_mode idle", 24, true);
        add(_storyModeBtn);

        // 3. Configurar Botón de Freeplay
        _freeplayBtn = new FlxSprite(_freeplayBaseX, 250); // Separado a 250 en Y para que no se encima
        _freeplayBtn.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/mainmenu/menu_freeplay.png", 
            "assets/shared/images/mainmenu/menu_freeplay.xml"
        );
        // Usamos los nombres invertidos tal como descubrimos para arreglar tu bug de animación
        _freeplayBtn.animation.addByPrefix("idle", "freeplay selected", 24, true);
        _freeplayBtn.animation.addByPrefix("selected", "freeplay idle", 24, true);
        add(_freeplayBtn);

        // Activamos la selección inicial (Story Mode por defecto)
        changeSelection(0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Controles de navegación (Flechas o WASD)
        if (FlxG.keys.anyJustPressed([UP, W]))
        {
            changeSelection(-1);
        }
        if (FlxG.keys.anyJustPressed([DOWN, S]))
        {
            changeSelection(1);
        }

        // Confirmar selección normal (Enter o Espacio)
        if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
        {
            goToState();
        }

        // --- MODO TEST DIRECTO (Tecla 7 o Numpad 7) ---
        //if (FlxG.keys.anyJustPressed([SEVEN, NUMPADSEVEN]))
       // {
        //    trace("Abriendo PlayState en Modo Test con JSON real...");
        //    PlayState.chartType = "psych";       // Forzamos el uso de PsychPlayState
     //       PlayState.currentSong = "test-song"; // Buscará assets/shared/data/test-song/test-song.json
      //      FlxG.switchState(new PlayState());   // Ejecuta el enrutador
       // }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        // Sistema de bucle (si subes de Story Mode vas a Freeplay, y viceversa)
        if (curSelected < 0)
            curSelected = 1;
        if (curSelected > 1)
            curSelected = 0;

        // --- Actualizar efectos visuales de Story Mode ---
        if (curSelected == 0)
        {
            _storyModeBtn.x = _storyBaseX + 10; // Se mueve 10px a la derecha
            _storyModeBtn.animation.play("selected");
        }
        else
        {
            _storyModeBtn.x = _storyBaseX; // Regresa a su lugar
            _storyModeBtn.animation.play("idle");
        }

        // --- Actualizar efectos visuales de Freeplay ---
        if (curSelected == 1)
        {
            _freeplayBtn.x = _freeplayBaseX + 10; // Se mueve 10px a la derecha
            _freeplayBtn.animation.play("selected");
        }
        else
        {
            _freeplayBtn.x = _freeplayBaseX; // Regresa a su lugar
            _freeplayBtn.animation.play("idle");
        }
    }

    function goToState():Void
    {
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