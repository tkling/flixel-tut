package;

import flixel.FlxGame;
import flixel.FlxG;
import flixel.util.FlxSave;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(320, 240, MenuState));
    setVolumeFromSave();
  }

  function setVolumeFromSave() {
    var save:FlxSave = new FlxSave();
    save.bind("flixel-tutorial");

    if (save.data.volume != null) {
        FlxG.sound.volume = save.data.volume;
    }
    
    save.close();
  }
}
