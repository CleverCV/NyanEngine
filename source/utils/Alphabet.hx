package utils;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;

class Alphabet extends FlxSpriteGroup
{
    public var text(default, set):String = "";
    
    private var _textWidth:Float = 0;
    private var _textSize:Float = 1.0;
    private var _isBold:Bool = false;

    public function new(x:Float, y:Float, text:String = "", isBold:Bool = false, textSize:Float = 1.0)
    {
        super(x, y);
        this._isBold = isBold;
        this._textSize = textSize;
        this.text = text;
    }

    private function set_text(newText:String):String
    {
        if (text == newText && members.length > 0) return text;
        
        text = newText;
        clearAlphabet();

        var startX:Float = 0;
        var startY:Float = 0;
        var spaceWidth:Float = 28 * _textSize;
        var rowHeight:Float = 70 * _textSize;

        for (i in 0...text.length)
        {
            var char:String = text.charAt(i);

            // Control de salto de línea
            if (char == "\n")
            {
                startX = 0;
                startY += rowHeight;
                continue;
            }

            // Control de espacio
            if (char == " ")
            {
                startX += spaceWidth;
                continue;
            }

            var letter:AlphaCharacter = new AlphaCharacter(startX, startY, char, _isBold);
            letter.scale.set(_textSize, _textSize);
            letter.updateHitbox();
            add(letter);

            // Avanzar cursor para la siguiente letra con un pequeño espacio
            startX += letter.width + (4 * _textSize);
        }

        _textWidth = startX;
        return text;
    }

    private function clearAlphabet():Void
    {
        while (members.length > 0)
        {
            var obj = members.shift();
            if (obj != null) obj.destroy();
        }
    }
}

class AlphaCharacter extends FlxSprite
{
    // Mapeo de caracteres especiales a nombres seguros en el XML
    private static var _charMap:Map<String, String> = [
        "á" => "á",
        "é" => "é",
        "í" => "í",
        "ó" => "ó",
        "ú" => "ú",
        "ñ" => "ñ"
    ];

    public function new(x:Float, y:Float, char:String, isBold:Bool = false)
    {
        super(x, y);
        
        // Carga el Atlas (Asegúrate de que la ruta a tu PNG y XML sea correcta)
        frames = FlxAtlasFrames.fromSparrow('assets/shared/images/alphabet.png', 'assets/shared/images/alphabet.xml');

        var animType:String = "lowercase";
        if (isBold)
        {
            animType = "bold";
        }
        else if (char == char.toUpperCase() && char != char.toLowerCase())
        {
            animType = "uppercase";
        }

        var charKey:String = _charMap.exists(char) ? _charMap.get(char) : char;

// Por esto (el formato correcto de tu XML):
        var animName:String = charKey + " " + animType + " instance 10000";
        animation.addByPrefix('idle', animName, 24, true);
        animation.play('idle');
        
        if (animation.curAnim == null)
        {
            visible = false;
        }
    }
}