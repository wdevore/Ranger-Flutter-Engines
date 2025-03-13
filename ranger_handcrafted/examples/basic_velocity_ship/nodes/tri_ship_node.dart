import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

// The ship is initially pointed in the -Y direction.
// So the initial angle--relative to +X--is 90 CCW. A positive rotation yields
// a CCW rotation.
// The velocity vector needs to be aligned/initialized relative to +X axis.

class Thrust {
  // This is the direction and magnitude of the thrust.
  // When thrust is applied the magnitude is increases at a specified rate.
  // When thrust is removed the magnitude decays to zero at a specified rate.
  late core.Velocity velocity = core.Velocity.upDirection();
  final double increaseRate = 0.001;
  final double decreaseRate = 0.0005;
  bool thrustOn = false;
  double angularOffset = 0.0;

  void applyThrust() {
    thrustOn = true;
  }

  void removeThrust() {
    thrustOn = false;
  }

  void setMaxThrust(double mag) {
    velocity.maxMag = mag;
  }

  void update(double dt) {
    if (thrustOn) {
      velocity.magnitude += increaseRate * dt;
      if (velocity.magnitude > velocity.maxMag) {
        velocity.magnitude = velocity.maxMag;
      }
    } else {
      velocity.magnitude -= decreaseRate * dt;
      if (velocity.magnitude < 0.0) {
        velocity.magnitude = 0.0;
      }
    }
  }

  void setDirectionOffset() {
    setAngularOffset(-90.0 * core.degreesToRadians);
  }

  void setAngularOffset(double angle) {
    angularOffset = angle;
  }

  void changeDirectionBy(double angle) {
    velocity.setDirectionByAngle(angle + angularOffset);
  }
}

enum KeyStates {
  none,
  up,
  down,
}

// KeyRepeat causes KeyDown unassert. We need to check both Down and Up:
//         d u r
// KeyDown=T/F/F, KeyRepeat=F/F/T, KeyUp=F/T/F,    =F/F/F
//   active           active        non-active    non-active
// OR
// KeyDown=T/F/F, KeyUp=F/T/F
//
// These are the sequences to detect a Down/Up sequence.
// Because another key may be depressed while the current key is depressed,
// we need to track all keys states.
class KeyAction {
  final String key;
  KeyStates state = KeyStates.none;

  KeyAction(this.key);

  /// Return active (true) or not-active (false)
  KeyStates check(core.KeyboardEvent event) {
    if (event.key == key) {
      if (event.isKeyDown && !event.isKeyUp && !event.isKeyRepeat) {
        state = KeyStates.down;
        return state;
      }
      if (!event.isKeyDown && !event.isKeyUp && event.isKeyRepeat) {
        state = KeyStates.down;
        return state;
      }
      if (!event.isKeyDown && event.isKeyUp && !event.isKeyRepeat) {
        state = KeyStates.up;
        return state;
      }
      if (!event.isKeyDown && !event.isKeyUp && !event.isKeyRepeat) {
        state = KeyStates.none;
        return state;
      }
    }

    return state;
  }
}

class TriShipNode extends core.Node {
  late Paint paint = Paint();
  late core.TriangleShape shape;

  late core.WorldCore world;
  late core.Renderer renderer;

  double angle = 0.0;
  final double angularRate =
      0.1 * core.degreesToRadians; // radians per (1/framerate)

  final KeyAction fAction = KeyAction('F');
  final KeyAction laAction = KeyAction('Arrow Left');
  final KeyAction raAction = KeyAction('Arrow Right');

  final Thrust thrust = Thrust();

  TriShipNode();

  /// [parent] is of type Node not "Node?" because leaf nodes always have a
  /// parent.
  factory TriShipNode.create(
    String name,
    double initialAngle,
    core.WorldCore world,
    core.Node? parent,
  ) {
    TriShipNode ship = TriShipNode()
      ..initialize(name)
      ..parent = parent
      ..nodeMan = world.nodeManager
      ..world = world
      ..angle = initialAngle * core.degreesToRadians
      ..paint.color = Colors.white // default of "white";
      ..thrust.setMaxThrust(5.0)
      ..thrust.setDirectionOffset();

    ship.parent?.children.addLast(ship);
    ship.build(world.atlas);

    return ship;
  }

  void build(core.Atlas atlas) {
    thrust.changeDirectionBy(angle);

    // First create a shape that will be renderered.
    Path path = core.Atlas.createTrianglePath();
    shape = core.TriangleShape.create(path, name);
    shape.paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    // Add to Atlas for cache usage
    atlas.addShape(shape);

    // Sync bounds to path polygon.
    // bounds
    //   ..top = rect.top
    //   ..left = rect.left
    //   ..bottom = rect.bottom
    //   ..right = rect.right
    //   ..width = rect.width
    //   ..height = rect.height;

    // Now create a renderer using that shape.
    renderer = core.PathRenderer.create(shape);

    // We want input events from Mouse
    world.nodeManager.registerForEvents(this);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('TriShipNode.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO) (Only called if this Node registered itself)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event, double dt) {
    if (event is core.KeyboardEvent) {
      KeyStates actionState = fAction.check(event);
      if (actionState != KeyStates.none) {
        if (actionState == KeyStates.down) {
          thrust.applyThrust();
        } else if (actionState == KeyStates.up) {
          thrust.removeThrust();
        }
      }

      actionState = laAction.check(event);
      if (actionState != KeyStates.none) {
        if (actionState == KeyStates.down) {
          angle -= angularRate * dt;
          thrust.changeDirectionBy(angle);
        }
      }

      actionState = raAction.check(event);
      if (actionState != KeyStates.none) {
        if (actionState == KeyStates.down) {
          angle += angularRate * dt;
          thrust.changeDirectionBy(angle);
        }
      }
    }
  }

  @override
  void render(core.Matrix4 model, Canvas canvas, Size size) {
    renderer.render(model, canvas, this);
    // Finally call render incase the base Node wants to decorate/adorn it.
    super.render(model, canvas, size);
  }

  @override
  void update(double dt) {
    switch (state) {
      default:
        // Default is where most of the action takes place.
        setRotation(angle);

        // Apply thrust force to ship's position.
        thrust.update(dt);
        thrust.velocity.applyToPoint(position);

        break;
    }
  }
}
