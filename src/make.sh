# Just a reminder on how tt.cc is built.

g++ -I/scratch/neunhoef/Singular/Singular-3-1-3/x86_64-Linux/include -o tt tt.cc -L/scratch/neunhoef/Singular/Singular-3-1-3/Singular -lsingular
export LD_LIBRARY_PATH=/scratch/neunhoef/Singular/Singular-3-1-3/Singular
strace ./tt >guck 2>guck2
