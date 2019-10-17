package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite> {
  var _sprBackground:FlxSprite;
  var _txtHealth:FlxText;
  var _txtMoney:FlxText;
  var _sprHealth:FlxSprite;
  var _sprMoney:FlxSprite;

  public function new() {
    super();
    _sprBackground = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
    _sprBackground.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
    add(_sprBackground);

    _txtHealth = new FlxText(16, 2, 0, "3 / 3", 8);
    _txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);    
    add(_txtHealth);

    _sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, AssetPaths.health__png);
    add(_sprHealth);

    _txtMoney = new FlxText(0, 2, 0, "0", 8);
    _sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4, AssetPaths.coin__png);
    _txtMoney.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
    _txtMoney.alignment = RIGHT;
    _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
    add(_sprMoney);
    add(_txtMoney);

    forEach(function(spr:FlxSprite) {
        spr.scrollFactor.set(0, 0);
    });
  }

  public function updateHUD(Health:Int = 0, Money:Int = 0):Void {
    _txtHealth.text = Std.string(Health) + " / 3";
    _txtMoney.text = Std.string(Money);
    _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
  }
}