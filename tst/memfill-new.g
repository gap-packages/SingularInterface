# TODO: Memfill test:

# Just create a Singular matrix and then access an entry via SI_[.
# Turn the matrix into a GAP matrix this way:

ExplodeSingMatToGAPMat := function(sing_mat)
    local M, i, j, rows, cols;
    rows := TODO;
    cols := TODO;
    M := [];
    for i in [1..rows] do
        M[i] := [];
        for j in [1..cols] do
            M[i][j] := SI_\[(sing_mat, j, i);
        od;
    od;
end;

# Call ExplodeSingMatToGAPMat a couple hundred times
# on an initial matrix and watch memory usage explode.

    