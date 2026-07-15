package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.scaleModes.RatioScaleMode; // Importamos el modo de escala proporcional
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// 1. Forzamos la resolución de diseño original en todas las plataformas
		var gameWidth:Int = 1280;
		var gameHeight:Int = 720;

		// 2. Iniciamos el juego
		var game = new FlxGame(gameWidth, gameHeight, MainMenu, 60, 60, true);
		addChild(game);

		// 3. Ajustamos el modo de escala para móviles después de que cargue el juego
		#if mobile
		FlxG.scaleMode = new RatioScaleMode();
		#end
	}
}