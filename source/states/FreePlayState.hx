package states;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class FreePlayState extends FlxState
{
    var _bg:FlxSprite;
    
    // Lista de canciones que aparecerán en tu menú (agrega o cambia los nombres aquí)
    var songs:Array<String> = ["Tutorial", "Bopeebo", "Fresh", "Dad Battle", "Test Song"];
    
    // Grupo para controlar todos los textos de las canciones
    var grpSongs:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override public function create():Void
    {
        super.create();

        // 1. Cargamos el fondo amarillo que pediste
        _bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
        add(_bg);

        // 2. Título superior estático
        var titleText = new FlxText(0, 20, 0, "FREEPLAY MENU", 40);
        titleText.screenCenter(X);
        titleText.setFormat(null, 40, 0xFF000000, CENTER); // Texto negro
        add(titleText);

        // 3. Crear los textos de las canciones dinámicamente
        grpSongs = new FlxTypedGroup<FlxText>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
            // Espaciamos cada texto verticalmente en base a su índice (i * 60)
            var songText = new FlxText(80, 150 + (i * 60), 0, songs[i], 32);
            songText.setFormat(null, 32, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000); // Texto blanco con borde negro
            songText.ID = i; // Guardamos su ID para identificarlo
            grpSongs.add(songText);
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
            PlayState.currentSong = selectedSongName; // El parser buscará la carpeta de esta canción automáticamente
            
            FlxG.switchState(new PlayState());
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        // Limites de la lista (Lazo/Bucle)
        if (curSelected < 0)
            curSelected = songs.length - 1;
        if (curSelected >= songs.length)
            curSelected = 0;

        // Cambiar estilos visuales (Color y posición en X) según esté seleccionada o no
        grpSongs.forEach(function(txt:FlxText) {
            if (txt.ID == curSelected)
            {
                txt.color = 0xFFFFFF00; // Amarillo brillante si está seleccionada
                txt.x = 110;            // Se mueve ligeramente a la derecha (+30px de base)
            }
            else
            {
                txt.color = 0xFFFFFFFF; // Blanco normal si es inactiva
                txt.x = 80;             // Posición original
            }
        });
    }
}