package states;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Alphabet; // Importamos tu clase Alphabet

class FreePlayState extends FlxState
{
    var _bg:FlxSprite;
    
	// Lista de canciones que aparecerán en tu menú
	var songs:Array<String> = ["tutorial", "bopeebo", "fresh", "dad battle", "test song"];
    
	// Grupo modificado para controlar los objetos Alphabet de las canciones
	var grpSongs:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;

    override public function create():Void
    {
        super.create();

		// 1. Cargamos el fondo amarillo
        _bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
        add(_bg);

		// 2. Título superior dinámico usando Alphabet (Bold para que resalte)
		var titleText = new Alphabet(0, 40, "FREEPLAY MENU", true, 1.0);
		titleText.screenCenter(X);
        add(titleText);

		// 3. Crear los textos del alfabeto para las canciones dinámicamente
		grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
			// Espaciamos cada 'alphb' verticalmente basándonos en tu diseño original (i * 90)
			// Usamos 'true' para Bold si quieres la tipografía de menú clásica de FNF
			var alphb:Alphabet = new Alphabet(80, 180 + (i * 90), songs[i], true, 0.9);
			alphb.ID = i; // Guardamos su ID para identificarlo
			grpSongs.add(alphb);
        }

        // Aplicamos la selección inicial
        changeSelection(0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Navegación de la lista
        if (FlxG.keys.anyJustPressed([UP, W]))
        {
            changeSelection(-1);
        }
        if (FlxG.keys.anyJustPressed([DOWN, S]))
        {
            changeSelection(1);
        }

        // Regresar al MainMenu con la tecla ESCAPE o BACKSPACE
        if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
        {
            FlxG.switchState(new MainMenu());
        }

        // Seleccionar canción con ENTER
        if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
        {
            var selectedSongName = songs[curSelected];
            trace("Cargando chart para: " + selectedSongName);

            // Configuramos los datos en el enrutador antes de cambiar
            PlayState.chartType = "psych"; 
			PlayState.currentSong = selectedSongName; 
            
            FlxG.switchState(new PlayState());
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

		// Límites de la lista (Lazo/Bucle)
        if (curSelected < 0)
            curSelected = songs.length - 1;
        if (curSelected >= songs.length)
            curSelected = 0;

		// Modificar los estados visuales del Alphabet grupalmente
		grpSongs.forEach(function(alphb:Alphabet)
		{
			if (alphb.ID == curSelected)
			{
				alphb.color = 0xFFFFFF00; // Tinte Amarillo brillante para el texto seleccionado
				alphb.alpha = 1.0; // Totalmente visible
				alphb.x = 110; // Se mueve ligeramente a la derecha (+30px)
            }
            else
            {
				alphb.color = 0xFFFFFFFF; // Blanco / color original sin tintar
				alphb.alpha = 0.6; // Opacidad reducida para las letras inactivas
				alphb.x = 80; // Regresa a su posición X base
            }
        });
    }
}