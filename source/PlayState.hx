package;

import flixel.FlxG;
import flixel.FlxState;
import parsers.PsychParser;
import parsers.VSliceParser;
import states.PsychPlayState;
import states.VSlicePlayState;

class PlayState extends FlxState
{
    // ¡Asegúrate de que tengan 'public static var' para que FreePlayState las pueda ver!
    public static var currentSong:String = "tutorial";
    public static var chartType:String = "psych"; 

    override public function create():Void
    {
        super.create();

        // El enrutador revisa el tipo de chart e inicializa el parser correcto
        if (chartType == "vslice")
        {
            trace("Cargando Chart de V-Slice...");
            var parsedData = V_SliceParser.parseChart(currentSong);
            FlxG.switchState(new V_SlicePlayState(parsedData));
        }
        else
        {
            trace("Cargando Chart de Psych Engine...");
            var parsedData = PsychParser.parseChart(currentSong);
            FlxG.switchState(new PsychPlayState(parsedData));
        }
    }
}