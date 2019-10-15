package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

class PlayState extends FlxState {
  var _player:Player;
  var _map:FlxOgmoLoader;
  var _walls:FlxTilemap;

  override public function create():Void {
    _map = new FlxOgmoLoader(AssetPaths.level__oel);
    _walls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
    _walls.follow();
    _walls.setTileProperties(1, FlxObject.NONE);
    _walls.setTileProperties(2, FlxObject.ANY);
    add(_walls);

    _player = new Player();
    add(_player);

    _map.loadEntities(placeEntities, "entities");

    super.create();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    FlxG.collide(_player, _walls);
  }

  function placeEntities(entityName:String, entityData:Xml):Void {
    var x:Int = Std.parseInt(entityData.get("x"));
    var y:Int = Std.parseInt(entityData.get("y"));

    if (entityName == "player") {
      _player.x = x;
      _player.y = y;
    }
  }
}
