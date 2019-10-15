package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite {
  public var speed:Float = 200;

  public function new(?X:Float=0, ?Y:Float=0) {
    super(X, Y);
    makeGraphic(16, 16, FlxColor.BLUE);
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
      velocity.set(speed, 0);
      velocity.rotate(FlxPoint.weak(0, 0), determineAngle(up, down, left, right));
    }
  }

  function determineAngle(up, down, left, right):Float {
    var angle:Float = 0;

    if (up) {
      angle = -90;
      if (left)
        angle -= 45;
      else if (right)
        angle += 45;
    } else if (down) {
      angle = 90;
      if (left)
        angle += 45;
      else if (right)
        angle -= 45;
    } else if (left) {
      angle = 180;
    } else if (right) {
      angle = 0;
    }

    return angle;
  }
}