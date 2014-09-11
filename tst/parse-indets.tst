gap> # Basics
gap> _ParseIndeterminatesDescription("x");
[ "x" ]
gap> _ParseIndeterminatesDescription("xxx");
[ "xxx" ]
gap> _ParseIndeterminatesDescription("x,y,z");
[ "x", "y", "z" ]

gap> # Allow whitespace
gap> _ParseIndeterminatesDescription("x, y, z");
[ "x", "y", "z" ]

gap> # ranges
gap> _ParseIndeterminatesDescription("x_3..4");
[ "x_3", "x_4" ]
gap> _ParseIndeterminatesDescription("x4..4");
[ "x4" ]
gap> _ParseIndeterminatesDescription("y0..12");
[ "y0", "y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", 
  "y12" ]


gap> # complex expressions
gap> _ParseIndeterminatesDescription("xyz,aB_c2..3");
[ "xyz", "aB_c2", "aB_c3" ]
gap> _ParseIndeterminatesDescription("a5b7..9");
[ "a5b7", "a5b8", "a5b9" ]
gap> _ParseIndeterminatesDescription(" x3..4, y0..12, z ");
[ "x3", "x4", "y0", "y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", 
  "y10", "y11", "y12", "z" ]


gap> # Some bogus inputs
gap> _ParseIndeterminatesDescription("x/");
Error, 'x/' is not a valid identifier
gap> _ParseIndeterminatesDescription("x..4");
Error, Text left of '..' must end with at least one digit (in 'x..4')
gap> _ParseIndeterminatesDescription("1..4");
Error, Text left of '..' must contain at least one non-digit (in '1..4')
gap> _ParseIndeterminatesDescription("x1..");
Error, Invalid input 'x1.. ends with with '.'
gap> _ParseIndeterminatesDescription("1..");
Error, Invalid input '1.. ends with with '.'
gap> _ParseIndeterminatesDescription("x1..4x");
Error, Text right of '..' must not contain any non-digits (in 'x1..4x')
gap> _ParseIndeterminatesDescription("x1...5");
Error, Too many '.' in 'x1...5'
gap> _ParseIndeterminatesDescription("x1..5.");
Error, Invalid input 'x1..5. ends with with '.'
gap> _ParseIndeterminatesDescription("x5..1");
Error, Invalid range in 'x5..1'

gap> _ParseIndeterminatesDescription("x5..1)");
Error, Text right of '..' must not contain any non-digits (in 'x5..1)')
gap> _ParseIndeterminatesDescription("x(5..1");
Error, Invalid format in 'x(5..1'
gap> _ParseIndeterminatesDescription("x5(..1)");
Error, Invalid format in 'x5(..1)'
gap> _ParseIndeterminatesDescription("x(y5..1)");
Error, Invalid format in 'x(y5..1)'



gap> # ranges (Singular style)
gap> _ParseIndeterminatesDescription("x_(3..4)");
[ "x_(3)", "x_(4)" ]
gap> _ParseIndeterminatesDescription("x(4..4)");
[ "x(4)" ]
gap> _ParseIndeterminatesDescription("y(0..12)");
[ "y(0)", "y(1)", "y(2)", "y(3)", "y(4)", "y(5)", "y(6)", "y(7)", "y(8)",
  "y(9)", "y(10)", "y(11)", "y(12)" ]
gap> _ParseIndeterminatesDescription("x1(1..2)");
[ "x1(1)", "x1(2)" ]

gap> _ParseIndeterminatesDescription("x(1)(2)(-17)");
[ "x(1)(2)(-17)" ]
gap> _ParseIndeterminatesDescription("x(1)(2..3)(12..17)");
[ "x(1)(2)(12)", "x(1)(2)(13)", "x(1)(2)(14)", "x(1)(2)(15)", "x(1)(2)(16)",
  "x(1)(2)(17)", "x(1)(3)(12)", "x(1)(3)(13)", "x(1)(3)(14)", "x(1)(3)(15)",
  "x(1)(3)(16)", "x(1)(3)(17)" ]
gap> _ParseIndeterminatesDescription("@(1)(2..3)(-18..-17)");
[ "@(1)(2)(-18)", "@(1)(2)(-17)", "@(1)(3)(-18)", "@(1)(3)(-17)" ]
gap> _ParseIndeterminatesDescription("x(1..3)");
[ "x(1)", "x(2)", "x(3)" ]
gap> _ParseIndeterminatesDescription("x(3..1)");
[ "x(3)", "x(2)", "x(1)" ]