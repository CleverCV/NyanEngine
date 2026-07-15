package parsers;

import haxe.Json;
import openfl.utils.Assets;

class PsychParser
{
    public static function parseChart(songName:String):Dynamic
    {
        // Convertimos el nombre a minúsculas y limpiamos espacios si es necesario
        var formattedSong = songName.toLowerCase().split(' ').join('-');
        
        // Ruta típica de un JSON de Psych Engine
        var jsonPath = "assets/shared/data/" + formattedSong + "/" + formattedSong + ".json";
        
        trace("PsychParser: Intentando cargar JSON desde: " + jsonPath);

        try {
            if (Assets.exists(jsonPath))
            {
                var jsonRaw = Assets.getText(jsonPath);
                var parsedJson = Json.parse(jsonRaw);
                
                // Psych Engine guarda los datos reales dentro de un objeto llamado "song"
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

    // Un chart de emergencia por si no encuentra tu archivo JSON para que el juego no crasheé
    private static function createFallbackChart(songName:String):Dynamic
    {
        var dummyNotes:Array<Dynamic> = [];
        for (i in 0...40) {
			// Estructura REAL de nota de Psych Engine:
			// [strumTime (Float), noteData (Int), sustainLength (Float), noteType (String/Int)]

			// Haremos que cada 5 notas aparezca una nota larga de 800 milisegundos para probar
			var sustainDuration:Float = (i % 5 == 0) ? 800.0 : 0.0;

			dummyNotes.push([
				1000 + (i * 300), // strumTime
				i % 4, // noteData (0-3 para el jugador, 4-7 para el rival)
				sustainDuration, // sustainLength (duración de la nota larga)
				0 // noteType (0 = normal)
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