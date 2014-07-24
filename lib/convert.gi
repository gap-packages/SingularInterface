# Convert GAP polynomials to Singular polynomials in a given ring
# Args: Singular ring, GAP polynomial[, gensGAP, gensSI]
#
# By default, this guesses how to map the indeterminates based on
# their names. However, the user may also pass a list gensGAP of GAP
# indeterminates plus a list gensSI of Singular "indeterminates";
# then gensGAP[i] is mapped to gensSI[i].
# If this fails to specify for all indeterminates occurring in the
# polynomial f how they should be mapped, an error is raised.
#
# TODO: Do we really want the optional lists of generators as parameters,
#       or should we leave this to methods of the Value() operation (see below)?
# TODO: Merge converter into SI_poly(?) / SI_FromGAP / SI_ToGAP, or at least
#       make use of them there.
#       Perhaps a more generic "type conversion" interface is needed... this
#       is in fact something that affects more than just libsing.
# TODO: write test cases
# TODO: if gensGAP and gensSI are given, we could allow the user
#       to omit the Singular ring, as we only ever need it to
#       compute gensSI.
#
SI_polyFromGAP := function(arg)
    local s, f, gensGAP, tmp, gensSI, fam, e, g, i, c, t, j, k;

    if not Length(arg) in [2, 4] then
        Error("Wrong number of arguments, expected (siRing, gapPoly[, gensGAP, gensSI])");
    fi;

    s := arg[1];
    f := arg[2];
    e := ExtRepPolynomialRatFun(f);
    
    # TODO: verify that the coefficient rings of s and f match
    # TODO: add support for coefficient rings beyond prime fields and integers

    if Length(arg) = 2 then
        # User did not tell us how to map indeterminates.
        # Make an educated guess based on the names of the indeterminates
        
        # Compute list of GAP indeterminates occurring in f
        gensGAP := [];
        for i in [1,3..Length(e)-1] do
            UniteSet(gensGAP, e[i]{[1,3..Length(e[i])-1]});
        od;
        
        
        # Map generators by name
        tmp := SI_Indeterminates(s);
        gensSI := [];
        fam := CoefficientsFamily(FamilyObj(f));
        for i in [1..Length(gensGAP)] do
            g := Indeterminate(fam, gensGAP[i]);
            j := PositionProperty(tmp, x -> String(x) = String(g));
            if j = fail then
                Error("Could not determine how to map indeterminates (",g," -> ?)\n");
            fi;
            Add(gensSI, tmp[j]);
        od;
    else
        gensGAP := arg[3];
        gensSI := arg[4];
        # TODO: those lists could contain strings (= variable names)
        # or numbers (= generator indices), or actual polynomials consisting
        # of a single indeterminate.
        # Convert each of those to a uniform representation,
        # namely ids for gensGAP and polynomials for gensSI.
        Error("TODO");
    fi;
    
    g := Zero(s);
    for i in [1,3..Length(e)-1] do
        c := e[i+1];
        if IsFFE(c) then c := IntFFE(c); fi;
        # TODO: the following code is sub-optimal
        # Perhaps use this instead:
        #    SI_monomial(s,SI_intvec([1,2,3,4,...]));
        t := One(s);
        for j in [1,3..Length(e[i])-1] do
            k := PositionSet(gensGAP, e[i][j]);
            t := t * gensSI[k] ^ e[i][j+1];
        od;
        g := g + c * t;
    od;

    return g;
end;

# Convert Singular polynomials to GAP polynomials
# Args:  Singular polynomial[, gensSI, gensGAP]
#
# Note: No GAP polynomial ring is given, instead we "guess" the right
# coefficient domains. This should be enough, but perhaps not, in which
# case we should allow to optionally pass in a GAP ring as first argument.
# and map generators by name.
SI_polyToGAP := function(arg)
    Error("TODO");
end;


# Note: Both of these functions can also be viewed as variation of the
# GAP operation Value(), at least in the case where lists of generators
# are given. Its signatures:
#
# * Value( ratfun, indets, vals[, one] )
# * Value( upol, value[, one] )
#
# It can be used for conversion like this already now (at least for
# supported coefficient rings, which means char 0 right now):
#
#   f := SOME GAP POLYNOMIAL;
#   gensGAP := IndeterminatesOfPolynomialRing(R);
#   gensSI := SI_Indeterminates(s);
#   Value(f, gensGAP, gensSI);
#
# Conversely, we could install a Value method for Singular polynomials.
# It would of course be useful beyond conversion.


# Another approach: provide methods for
#   PolynomialByExtRep(NC) / RationalFunctionByExtRep(NC)
# and
#   ExtRepPolynomialRatFun / ExtRepNumeratorRatFun / ExtRepDenominatorRatFun
# then let the user convert between polynomials via these ext reps.
#
# Problem: these use families, not rings.
# Also, the result is more  cumbersome for the user.
