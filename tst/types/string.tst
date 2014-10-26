gap> str := SI_string("abc");
<singular string:
abc>
gap> Length(str);
3
gap> SI_ToGAP(str);
"abc"
gap> str[1];
<singular string:
a>
gap> Display(str);
abc
