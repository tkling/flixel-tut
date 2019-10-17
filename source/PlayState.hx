package;

import flixel.FlxG;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
  var _player:Player;
  var _map:FlxOgmoLoader;
  var _walls:FlxTilemap;
  var _coins:FlxTypedGroup<Coin>;
  var _enemies:FlxTypedGroup<Enemy>;
  var _hud:HUD;
  var _money:Int = 0;
  var _health:Int = 3;
  var _inCombat:Bool = false;
  var _combatHud:CombatHUD;
  var _ending:Bool;
  var _won:Bool;

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

    _hud = new HUD();
    add(_hud);

     _combatHud = new CombatHUD();
    add(_combatHud);

    _map.loadEntities(placeEntities, "entities");

    super.create();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    if (_ending) {
     return;
    }

    if (!_inCombat) {
      FlxG.collide(_player, _walls);
      FlxG.overlap(_player, _coins, playerTouchCoin);
      FlxG.collide(_enemies, _walls);
      _enemies.forEachAlive(checkEnemyVision);
      FlxG.overlap(_player, _enemies, playerTouchEnemy);
    } else {
      if (!_combatHud.visible) {
        _health = _combatHud.playerHealth;
        _hud.updateHUD(_health, _money);
        if (_combatHud.outcome == DEFEAT) {
          _ending = true;
          FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
        } else {
          if (_combatHud.outcome == VICTORY) {
            _combatHud.e.kill();
            if (_combatHud.e.etype == 1) {
              _won = true;
              _ending = true;
              FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
            }
          } else {
            _combatHud.e.flicker();
          }
          _inCombat = false;
          _player.active = true;
          _enemies.active = true;
        }
      }
    }
  }

  function doneFadeOut():Void {
    FlxG.switchState(new GameOverState(_won, _money));
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
      _money++;
      _hud.updateHUD(_health, _money);
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

  function playerTouchEnemy(P:Player, E:Enemy):Void {
    if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering()) {
      startCombat(E);
    }
  }

  function startCombat(E:Enemy):Void {
    _inCombat = true;
    _player.active = false;
    _enemies.active = false;
    _combatHud.initCombat(_health, E);
  }
}
