import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;

class MenuState extends FlxState {
  var _btnPlay:FlxButton;
  var _txtTitle:FlxText;
  var _btnOptions:FlxButton;

  override public function create():Void {
    _txtTitle = new FlxText(20, 0, 0, "HaxeFlixel\nTutorial\nGame", 22);
    _txtTitle.alignment = CENTER;
    _txtTitle.screenCenter(X);
    add(_txtTitle);

    _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
    _btnPlay.x = (FlxG.width / 2) - _btnPlay.width - 10;
    _btnPlay.y = FlxG.height - _btnPlay.height - 10;
    _btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
    add(_btnPlay);

    _btnOptions = new FlxButton(0, 0, "Options", clickOptions);
    _btnOptions.x = (FlxG.width / 2) + 10;
    _btnOptions.y = FlxG.height - _btnOptions.height - 10;
    _btnOptions.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
    add(_btnOptions);

    if (FlxG.sound.music == null) { // don't restart the music if it's already playing
      FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
    }

    super.create();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  function clickPlay():Void {
    flixel.FlxG.switchState(new PlayState());
  }

  function clickOptions():Void {
    FlxG.switchState(new OptionsState());
  }
}