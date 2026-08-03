package states;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Alphabet;

#if mobile
import flixel.ui.FlxVirtualPad;
#end

class FreePlayState extends FlxState
{
	var _bg:FlxSprite;

	// Lista vacía; se llenará desde el TXT
	var songs:Array<String> = [];

	var grpSongs:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;

	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

	override public function create():Void
	{
		super.create();

		// Inicializar datos de letras de Psych Engine
		utils.Alphabet.AlphaCharacter.loadAlphabetData();

		// 1. Cargar la lista de canciones desde assets/data/freeplaylist.txt
		songs = loadSongsFromTxt('assets/data/freeplaylist.txt');

		_bg = new FlxSprite(0, 0, "assets/shared/images/backgrounds/bg_yellow.png");
		add(_bg);

		// Título del menú usando minúsculas y bold = false (fuente normal)
		var titleText = new Alphabet(0, 20, "freeplay menu", false);
		titleText.screenCenter(X);
		add(titleText);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			// Constructor de Psych 0.7: (x, y, text, bold)
			var alphb:Alphabet = new Alphabet(120, 160 + (i * 135), songs[i], true);
			alphb.setScale(0.9); // Escala para ajustar el tamaño del texto
			alphb.ID = i;
			grpSongs.add(alphb);
		}

		changeSelection(0);

		#if mobile
		_virtualPad = new FlxVirtualPad(flixel.ui.FlxVirtualPad.FlxDPadMode.UP_DOWN, flixel.ui.FlxVirtualPad.FlxActionMode.A_B);
		_virtualPad.alpha = 0.75;

		var scaleFactor:Float = 1.5;
		if (_virtualPad.dPad != null)
		{
			_virtualPad.dPad.forEach(function(btn:flixel.ui.FlxButton)
			{
				btn.scale.set(scaleFactor, scaleFactor);
				btn.updateHitbox();
			});
		}

		if (_virtualPad.actions != null)
		{
			_virtualPad.actions.forEach(function(btn:flixel.ui.FlxButton)
			{
				btn.scale.set(scaleFactor, scaleFactor);
				btn.updateHitbox();
			});
		}

		_virtualPad.dPad.x += 15;
		_virtualPad.dPad.y -= 35;

		_virtualPad.actions.x -= 55;
		_virtualPad.actions.y -= 35;

		_virtualPad.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		add(_virtualPad);
		#end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var upPressed:Bool = false;
		var downPressed:Bool = false;
		var backPressed:Bool = false;
		var acceptPressed:Bool = false;

		#if mobile
		upPressed = FlxG.keys.anyJustPressed([UP, W]) || _virtualPad.getButton(UP).justPressed;
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]) || _virtualPad.getButton(DOWN).justPressed;
		backPressed = FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]) || _virtualPad.getButton(B).justPressed;
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]) || _virtualPad.getButton(A).justPressed;
		#else
		upPressed = FlxG.keys.anyJustPressed([UP, W]);
		downPressed = FlxG.keys.anyJustPressed([DOWN, S]);
		backPressed = FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]);
		acceptPressed = FlxG.keys.anyJustPressed([ENTER, SPACE]);
		#end

		if (upPressed)
		{
			changeSelection(-1);
		}
		if (downPressed)
		{
			changeSelection(1);
		}

		if (backPressed)
		{
			#if mobile
			if (_virtualPad != null)
				_virtualPad = flixel.util.FlxDestroyUtil.destroy(_virtualPad);
			#end
			FlxG.switchState(new MainMenu());
		}

		if (acceptPressed)
		{
			#if mobile
			if (_virtualPad != null)
				_virtualPad = flixel.util.FlxDestroyUtil.destroy(_virtualPad);
			#end

			var selectedSongName = songs[curSelected];
			trace("Cargando chart para: " + selectedSongName);

			PlayState.chartType = "psych"; 
			PlayState.currentSong = selectedSongName; 
			FlxG.switchState(new PlayState());
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		grpSongs.forEach(function(alphb:Alphabet)
		{
			if (alphb.ID == curSelected)
			{
				alphb.color = 0xFFFFFF00;
				alphb.alpha = 1.0;
				alphb.x = 150; 
			}
			else
			{
				alphb.color = 0xFFFFFFFF;
				alphb.alpha = 0.6;
				alphb.x = 120; 
			}
		});
	}
	// Función auxiliar para leer el TXT sin importar si es Windows o Mobile
	private function loadSongsFromTxt(path:String):Array<String>
	{
		var loadedList:Array<String> = [];

		#if sys
		if (sys.FileSystem.exists(path))
		{
			var rawText:String = sys.io.File.getContent(path);
			loadedList = rawText.split('\n');
			for (i in 0...loadedList.length)
			{
				loadedList[i] = StringTools.trim(loadedList[i]);
			}
		}
		#else
		if (openfl.utils.Assets.exists(path))
		{
			var rawText:String = openfl.utils.Assets.getText(path);
			loadedList = rawText.split('\n');
			for (i in 0...loadedList.length)
			{
				loadedList[i] = StringTools.trim(loadedList[i]);
			}
		}
		#end

		// Filtrar renglones vacíos
		loadedList = loadedList.filter(function(s:String) return s.length > 0);

		// Canción por defecto si el archivo no existe o está vacío
		if (loadedList.length == 0)
		{
			loadedList = ["tutorial"];
		}

		return loadedList;
	}
}