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
            // Estructura típica de nota FNF: [strumTime, noteData, mustache/mustHit]
            dummyNotes.push([1000 + (i * 300), i % 4, (i % 2 == 0 ? true : false)]);
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