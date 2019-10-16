package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Enemy extends FlxSprite {
  public var speed:Float = 140;
  public var etype(default, null):Int;
  public var seesPlayer:Bool = false;
  public var playerPosition(default, null):FlxPoint;
  
  var _brain:FSM;
  var _idleTimer:Float;
  var _moveDirection:Float;

  public function new(X:Float=0, Y:Float=0, EType:Int) {
    super(X, Y);
    etype = EType;
    loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
    setFacingFlip(FlxObject.LEFT, false, false);
    setFacingFlip(FlxObject.RIGHT, true, false);
    animation.add("d", [0, 1, 0, 2], 6, false);
    animation.add("lr", [3, 4, 3, 5], 6, false);
    animation.add("u", [6, 7, 6, 8], 6, false);
    drag.x = drag.y = 10;
    width = 8;
    height = 14;
    offset.x = 4;
    offset.y = 2;
    _brain = new FSM(idle);
    _idleTimer = 0;
    playerPosition = FlxPoint.get();
  }

  override public function draw():Void {
    if ((velocity.x != 0 || velocity.y != 0) && !isTouching(FlxObject.ANY)) {
      if (Math.abs(velocity.x) > Math.abs(velocity.y)) {
        facing = velocity.x < 0 ? FlxObject.LEFT : FlxObject.RIGHT;
      } else {
        facing = velocity.y < 0 ? FlxObject.UP : FlxObject.DOWN;
      }

      switch (facing) {
        case FlxObject.LEFT, FlxObject.RIGHT:
          animation.play("lr");
        case FlxObject.UP:
          animation.play("u");
        case FlxObject.DOWN:
          animation.play("d");
      }
    }

    super.draw();
  }

  public function idle():Void {
    if (seesPlayer) {
      _brain.activeState = chase;
    } else if (_idleTimer <= 0) {
      if (FlxG.random.bool(1)) {
        _moveDirection = -1;
        velocity.x = velocity.y = 0;
      } else {
        _moveDirection = FlxG.random.int(0, 8) * 45;
        velocity.set(speed * 0.5, 0);
        velocity.rotate(FlxPoint.weak(), _moveDirection);
      }
      _idleTimer = FlxG.random.int(1, 4);
    } else {
      _idleTimer -= FlxG.elapsed;
    }
  }

  public function chase():Void {
    if (!seesPlayer) {
      _brain.activeState = idle;
    } else {
      FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(speed));
    }
  }

  override public function update(elapsed:Float):Void {
    _brain.update();
    super.update(elapsed);
  }
}