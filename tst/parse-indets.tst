gap> # Basics
gap> _ParseIndeterminatesDescription("x");
[ "x" ]
gap> _ParseIndeterminatesDescription("xxx");
[ "xxx" ]
gap> _ParseIndeterminatesDescription("x,y,z");
[ "x", "y", "z" ]
gap> 
gap> # Allow whitespace
gap> _ParseIndeterminatesDescription("x, y, z");
[ "x", "y", "z" ]
gap> 
gap> # ranges
gap> _ParseIndeterminatesDescription("x_3..4");
[ "x_3", "x_4" ]
gap> _ParseIndeterminatesDescription("x4..4");
[ "x4" ]
gap> _ParseIndeterminatesDescription("y0..12");
[ "y0", "y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", 
  "y12" ]
gap> 
gap> # complex expressions
gap> _ParseIndeterminatesDescription("xyz,aB_c2..3");
[ "xyz", "aB_c2", "aB_c3" ]
gap> _ParseIndeterminatesDescription("a5b7..9");
[ "a5b7", "a5b8", "a5b9" ]
gap> _ParseIndeterminatesDescription(" x3..4, y0..12, z ");
[ "x3", "x4", "y0", "y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", 
  "y10", "y11", "y12", "z" ]
gap> 
gap> 
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
