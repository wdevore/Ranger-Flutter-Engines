# basic_gameloop
This is bare minimum of building a game loop in flutter. Depends on ranger_core package.

# range_flame
A port of [Ranger-Go-IGE](https://github.com/wdevore/Ranger-Go-IGE/tree/master) to Flutter. It uses Flame engine.

# range_core
This is the Ranger game engine in a package.

# ranger_handcrafted
This is a basic gameloop enhanced for Ranger.

# Tasks
- Maths
  - Vectors ✓
  - Matrixs ✓
  - Velocity ✓
  - AffineTransform ✓
  - Velocity ✓
  - Zoom
  - Interpolation
  - Transforms ✓
- Nodes ✓
- Geometry
  - Point ✓
- IO
  - Gestures ✓
  - Keyboard
- Fonts
  - Vector  <=== **WORKING**
    - Static text
    - Dynamic text
- Audio
- *Textures* (optional)

# Vector fonts
A simple vector line based flat file format.
Regular expression: 
```re
([0-9.-]+),([0-9.-]+)
```

For example:
```
A
-0.5,0.5 0.0,-0.5 0.5,0.5    <--- 1st poly line
-0.25,0.0 0.25,0.0            <--- 2nd poly line
EOC
EOF
```
The fonts are defined in a Unit square.
```
      (-0.5,-0.5)
            .----------------------.
            |          |           |
            |          |           |
            |          |           |
            |          |           |
            .--------(0,0)---------.
            |          |           |
            |          |           |
            |          |           |
            |          |           |
            .----------------------.
                                  (0.5,0.5)
```
