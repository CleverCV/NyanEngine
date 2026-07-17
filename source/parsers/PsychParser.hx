package parsers;

import haxe.Json;
import openfl.utils.Assets;

class PsychParser
{
    public static function parseChart(songName:String):Dynamic
	{
        var formattedSong = songName.toLowerCase().split(' ').join('-');

        var jsonPath = "assets/shared/data/" + formattedSong + "/" + formattedSong + ".json";
        
		trace("PsychParser: Intentando cargar el chart para PsychEngine: " + jsonPath);

        try {
            if (Assets.exists(jsonPath))
            {
                var jsonRaw = Assets.getText(jsonPath);
                var parsedJson = Json.parse(jsonRaw);

                if (parsedJson.song != null) {
                    return parsedJson.song;
                }
                return parsedJson;
            }
            else
            {
                trace("¡ALERTA! No se encontró el archivo JSON en la ruta. Usando datos por defecto.");
                return createFallbackChart(songName);
            }
        } catch(e:Dynamic) {
            trace("Error al parsear el JSON: " + e);
            return createFallbackChart(songName);
        }
    }

    private static function createFallbackChart(songName:String):Dynamic
    {
        var dummyNotes:Array<Dynamic> = [];
		for (i in 0...40)
		{
			var sustainDuration:Float = (i % 5 == 0) ? 800.0 : 0.0;

			dummyNotes.push([
			1000 + (i * 300), i % 4, sustainDuration, 0 
			]);
        }

        return {
            song: songName,
            speed: 2.5,
            notes: [
                {
                    sectionNotes: dummyNotes,
                    mustHitSection: true
                }
            ]
        };
    }
}