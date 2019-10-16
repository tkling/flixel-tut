package;

import flixel.FlxG;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState {
  var _player:Player;
  var _map:FlxOgmoLoader;
  var _walls:FlxTilemap;
  var _coins:FlxTypedGroup<Coin>;
  var _enemies:FlxTypedGroup<Enemy>;

  override public function create():Void {
    _map = new FlxOgmoLoader(AssetPaths.level__oel);
    _walls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
    _walls.follow();
    _walls.setTileProperties(1, FlxObject.NONE);
    _walls.setTileProperties(2, FlxObject.ANY);
    add(_walls);

    _coins = new FlxTypedGroup<Coin>();
    add(_coins);

    _enemies = new FlxTypedGroup<Enemy>();
    add(_enemies);

    _player = new Player();
    add(_player);
    FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN, 1);

    _map.loadEntities(placeEntities, "entities");

    super.create();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    FlxG.collide(_player, _walls);
    FlxG.overlap(_player, _coins, playerTouchCoin);
    FlxG.collide(_enemies, _walls);
    _enemies.forEachAlive(checkEnemyVision);
  }

  function placeEntities(entityName:String, entityData:Xml):Void {
    var x:Int = Std.parseInt(entityData.get("x"));
    var y:Int = Std.parseInt(entityData.get("y"));

    if (entityName == "player") {
      _player.x = x;
      _player.y = y;
    } else if (entityName == "coin") {
      _coins.add(new Coin(x+4, y+4));
    } else if (entityName == "enemy") {
      _enemies.add(new Enemy(x+4, y, Std.parseInt(entityData.get("etype"))));
    }
  }

  function playerTouchCoin(player:Player, coin:Coin) {
    if (player.alive && player.exists && coin.alive && coin.exists) {
      coin.kill();
    }
  }

  function checkEnemyVision(enemy:Enemy):Void {
    if (_walls.ray(enemy.getMidpoint(), _player.getMidpoint())) {
      enemy.seesPlayer = true;
      enemy.playerPosition.copyFrom(_player.getMidpoint());
    } else {
      enemy.seesPlayer = false;
    }
  }
}
