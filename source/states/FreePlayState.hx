package states;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Alphabet; // Importamos tu clase Alphabet

#if mobile
import flixel.ui.FlxVirtualPad;
#end

class FreePlayState extends FlxState
{
    var _bg:FlxSprite;
    
	// Lista de canciones que aparecerán en tu menú
	var songs:Array<String> = ["tutorial", "bopeebo", "fresh", "dad battle", "test song"];
    
	// Grupo modificado para controlar los objetos Alphabet de las canciones
	var grpSongs:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;

	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

    override public function create():Void
    {
        super.create();

		// 1. Cargamos el fondo amarillo
        _bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
        add(_bg);

		// 2. Título superior dinámico usando Alphabet (Bold para que resalte)
		var titleText = new Alphabet(0, 20, "FREEPLAY MENU", true, 1.0);
		titleText.screenCenter(X);
        add(titleText);

		// 3. Crear los textos del alfabeto para las canciones dinámicamente
		grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
			// CAMBIADO: Mayor separación vertical (i * 135) y movido a la derecha en X (120) para evitar que se amontone
			var alphb:Alphabet = new Alphabet(120, 160 + (i * 135), songs[i], true, 0.9);
			alphb.ID = i; // Guardamos su ID para identificarlo
			grpSongs.add(alphb);
        }

        // Aplicamos la selección inicial
        changeSelection(0);

		// 4. Agregar Virtual Pad para Android y hacerlo más grande
		#if mobile
		_virtualPad = new FlxVirtualPad(flixel.ui.FlxVirtualPad.FlxDPadMode.UP_DOWN, flixel.ui.FlxVirtualPad.FlxActionMode.A_B);
		_virtualPad.alpha = 0.75;

		// --- Hacemos los botones más grandes ---
		var scaleFactor:Float = 1.5; // Ajusta este número (1.5 = 50% más grande, 2.0 = el doble de grande)

		// Escalar los botones del D-Pad (Flechas)
		if (_virtualPad.dPad != null)
		{
			_virtualPad.dPad.forEach(function(btn:flixel.ui.FlxButton)
			{
				btn.scale.set(scaleFactor, scaleFactor);
				btn.updateHitbox(); // Súper importante para que la zona táctil coincida con el nuevo tamaño gráfico
			});
		}

		// Escalar los botones de acción (A y B)
		if (_virtualPad.actions != null)
		{
			_virtualPad.actions.forEach(function(btn:flixel.ui.FlxButton)
			{
				btn.scale.set(scaleFactor, scaleFactor);
				btn.updateHitbox();
			});
		}

		// --- Reposicionar los botones para que no se corten en las esquinas ---
		// Desplaza el D-Pad un poco hacia la derecha y arriba para compensar la escala
		_virtualPad.dPad.x += 15;
		_virtualPad.dPad.y -= 35;

		// Desplaza los botones A y B un poco hacia la izquierda y arriba
		_virtualPad.actions.x -= 55;
		_virtualPad.actions.y -= 35;

		// Esto asegura que el pad se mueva al frente y no se escale de forma extraña:
		_virtualPad.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		add(_virtualPad);
		#end
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

		// --- ENTRADAS DE CONTROL (Teclado + Botones Virtuales) ---
		var upPressed:Bool = false;
		var downPressed:Bool = false;
		var backPressed:Bool = false;
		var acceptPressed:Bool = false;

		#if mobile
		// En móviles leemos tanto el teclado por si acaso como el Pad táctil
		upPressed = FlxG.keys.anyJustPressed([UP, W]) || _virtualPad.getButton(UP).justPressed;
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]) || _virtualPad.getButton(DOWN).justPressed;
		backPressed = FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]) || _virtualPad.getButton(B).justPressed;
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]) || _virtualPad.getButton(A).justPressed;
		#else
		// En PC solo leemos teclado
		upPressed = FlxG.keys.anyJustPressed([UP, W]);
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]);
		backPressed = FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]);
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]);
		#end

        // Navegación de la lista
		if (upPressed)
        {
            changeSelection(-1);
        }
		if (downPressed)
        {
            changeSelection(1);
        }

		// Regresar al MainMenu
		if (backPressed)
        {
			#if mobile
			if (_virtualPad != null)
				_virtualPad = flixel.util.FlxDestroyUtil.destroy(_virtualPad);
			#end
            FlxG.switchState(new MainMenu());
        }

		// Seleccionar canción
		if (acceptPressed)
        {
			#if mobile
			if (_virtualPad != null)
				_virtualPad = flixel.util.FlxDestroyUtil.destroy(_virtualPad);
			#end

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
				alphb.x = 150; // CAMBIADO: Se mueve ligeramente a la derecha (Base 120 + 30px offset)
            }
            else
            {
				alphb.color = 0xFFFFFFFF; // Blanco / color original sin tintar
				alphb.alpha = 0.6; // Opacidad reducida para las letras inactivas
				alphb.x = 120; // CAMBIADO: Regresa a su nueva posición X base de 120
            }
        });
    }
}