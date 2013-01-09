#ifndef SINGOBJ_H
#define SINGOBJ_H

// Prevent inline code from using tests which are not in libsingular:
#ifdef WANT_SW
#include <Singular/libsingular.h>
#else
#define NDEBUG 1
#define OM_NDEBUG 1

//#include <string>
#include <libsingular.h>

#endif


class SingObj {
    // This class is a wrapper around a Singular object of any type.
    // It keeps track whether or not it is its responsibility to free
    // the Singular object in the end or whether it has just borrowed
    // the object reference temporarily.
    // It can dig out the underlying singular object of a GAP
    // object together with its type and ring, this also works for
    // proxy objects. The Singular object is also automatically
    // wrapped for the Singular interpreter in an sleftv structure.
    // The object also keeps track of the GAP type number, the underlying
    // ring with its GAP number and a possible error that might have occurred.
    //
    // For the usual constructor taking a GAP object:
    // The GAP object input can be GAP integers (which produce
    // machine integers if possible and otherwise bigints), 
    // GAP strings, GAP wrappers for Singular objects, which produce the
    // corresponding Singular object, GAP proxy objects for subobjects
    // of other Singular objects, or GAP proxy objects for values in
    // Singular interpreter variables. Note that the resulting Singular
    // object is *not* copied. Use .copy afterwards if you want to hand
    // the result to something destructive.
    //
    // Note that if an error occurs, GAP will do a longjmp, so we cannot
    // rely on automatic destruction any more, we have to call cleanup
    // ourselves! This is why the error cannot be handled directly
    // in the methods of this object. It is possible that other objects
    // of the same type need to be told about the error.
  public:
    sleftv obj;
    int gtype;
    bool needcleanup;  // if this is true we have to destruct the Singular
                        // object when this object dies.
    const char *error;  // If non-NULL, an error has happened.
    UInt rnr;     // GAP number of the underlying Singular ring
    ring r;       // Underlying Singular ring.

    SingObj(Obj input, UInt &extrnr, ring &extr)
      { init(input,extrnr,extr); }
    SingObj(void)     // Default constructor for empty object
      : gtype(0), needcleanup(false), error(NULL), rnr(0), r(NULL)
      { obj.Init(); }
    void init(Obj input, UInt &extrnr, ring &extr);
      // This does the actual work
    ~SingObj(void) { cleanup(); }   // a mere convenience
    leftv destructiveuse(void)
      // Call this to get a pointer to the internal obj structure of type
      // sleftv if you intend to use the Singular object destructively.
      // If necessary, copy() is called automatically and any scheduled
      // cleanup on our side is prevented.
    {
        if (!needcleanup) copy();
        needcleanup = false;
        return &obj;
    }
    leftv nondestructiveuse(void)
      // Call this to get a pointer to the internal obj structure of type
      // sleftv if you intend to use the singular object non-destructively.
      // No automatic copy() is performed, if cleanup was scheduled it
      // will be done as scheduled later on.
    {
        return &obj;
    }
    void copy(void);      // Makes a copy if it is not already one
    void cleanup(void);   // Frees object if it was a copy
    Obj gapwrap(void);    // GAP-wraps the object
};



#endif
