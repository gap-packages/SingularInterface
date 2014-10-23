#! @Chapter Getting started

#! @Section First steps

#! @Subsection A short example

#!  Here is a short example in &Singular; 4.0.1 demonstrating some
#!  basic procedures. &Singular; uses <C>=</C> for assignments and
#!  suppresses any output while &GAP; uses <C>:=</C> for assignments
#!  and triggers the so-called <C>View</C>-method, which gives a very brief
#!  description of the object (unless suppressed by a trailing <C>;;</C>).
#!  Basically, &Singular;'s print procedure is mapped to the so-called
#!  <C>Display</C>-method in &GAP;. <P/>
#!  
#!  Start by loading &SingularInterface; in &GAP;.
#! @Example
LoadPackage( "SingularInterface" );
#! true
#! @EndExample
