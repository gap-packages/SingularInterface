#include <gmp.h>
#include <string>
#include <iostream>
#include <libsingular.h>

using namespace std;

int main(int argc, char *argv[])
{
    cout << "Hello\n";
    siInit("/home/neunhoef/4.0/pkg/libsingular/Singular-3-1-3/Singular/libsingular.so");
    for (int tok = 0;tok < MAX_TOK;tok++)
        cout << "Command:" << Tok2Cmdname(tok) << ":token:" 
             << tok << "\n";
    return 0;
}
