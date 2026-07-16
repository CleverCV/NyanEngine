package parsers;

class VSliceParser
{
	public static function parseChart(songName:String):Dynamic
	{
		trace("VSliceParser: Cargando formato V-Slice para " + songName);
		return {song: songName, speed: 2.8, type: "vslice_chart"};
	}
}