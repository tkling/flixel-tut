package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
// import flixel.util.FlxColor;

class Player extends FlxSprite {
  public var speed:Float = 200;
  public var graphicAngle:Float;

  public function new(?X:Float=0, ?Y:Float=0) {
    super(X, Y);
    // makeGraphic(16, 16, FlxColor.BLUE);
    loadGraphic(AssetPaths.player__png, true, 16, 16);
    setFacingFlip(FlxObject.LEFT, false, false);
    setFacingFlip(FlxObject.RIGHT, true, false);
    animation.add("lr", [3, 4, 3, 5], 6, false);
    animation.add("u", [6, 7, 6, 8], 6, false);
    animation.add("d", [0, 1, 0, 2], 6, false);
    drag.x = drag.y = 1600;
  }

  override public function update(elapsed:Float):Void {
    movement();
    super.update(elapsed);
  }

  function movement():Void {
    var up:Bool    = FlxG.keys.anyPressed([UP, W]);
    var down:Bool  = FlxG.keys.anyPressed([DOWN, S]);
    var left:Bool  = FlxG.keys.anyPressed([LEFT, A]);
    var right:Bool = FlxG.keys.anyPressed([RIGHT, D]);

    if (up && down)
      up = down = false;

    if (right && left)
      right = left = false;

    if (up || down || left || right) {
      setAngleAndFacing(up, down, left, right);

      velocity.set(speed, 0);
      velocity.rotate(FlxPoint.weak(0, 0), graphicAngle);

      setAnimation();
    }
  }

  function setAngleAndFacing(up, down, left, right):Void {
    if (up) {
      graphicAngle = -90;
      facing = FlxObject.UP;
      if (left)
        graphicAngle -= 45;
      else if (right)
        graphicAngle += 45;
    } else if (down) {
      graphicAngle = 90;
      facing = FlxObject.DOWN;
      if (left)
        graphicAngle += 45;
      else if (right)
        graphicAngle -= 45;
    } else if (left) {
      graphicAngle = 180;
      facing = FlxObject.LEFT;
    } else if (right) {
      graphicAngle = 0;
      facing = FlxObject.RIGHT;
    }
  }

  function setAnimation():Void {
    if ((velocity.x != 0 || velocity.y != 0) && !isTouching(FlxObject.ANY)) {
      switch(facing) {
      case FlxObject.RIGHT, FlxObject.LEFT:
        animation.play("lr");
      case FlxObject.UP:
        animation.play("u");
      case FlxObject.DOWN:
        animation.play("d");
      }
    }
  }
}