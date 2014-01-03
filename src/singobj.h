#ifndef SINGOBJ_H
#define SINGOBJ_H

// Prevent inline code from using tests which are not in libsingular:
#include <Singular/libsingular.h>

/// This class is a wrapper around a Singular object of any type.
/// It keeps track whether or not it is its responsibility to free
/// the Singular object in the end or whether it has just borrowed
/// the object reference temporarily.
/// It can dig out the underlying singular object of a GAP
/// object together with its type and ring, this also works for
/// proxy objects. The Singular object is also automatically
/// wrapped for the Singular interpreter in an sleftv structure.
/// The object also keeps track of the GAP type number, the underlying
/// ring with its GAP number and a possible error that might have occurred.
///
/// For the usual constructor taking a GAP object:
/// The GAP object input can be GAP integers (which produce
/// machine integers if possible and otherwise bigints),
/// GAP strings, GAP wrappers for Singular objects, which produce the
/// corresponding Singular object, GAP proxy objects for subobjects
/// of other Singular objects, or GAP proxy objects for values in
/// Singular interpreter variables. Note that the resulting Singular
/// object is *not* copied. Use .copy afterwards if you want to hand
/// the result to something destructive.
///
/// Note that if an error occurs, GAP will do a longjmp, so we cannot
/// rely on automatic destruction any more, we have to call cleanup
/// ourselves! This is why the error cannot be handled directly
/// in the methods of this object. It is possible that other objects
/// of the same type need to be told about the error.
class SingObj {
public:
    sleftv obj;
    int gtype;
    /// if this is true we have to destruct the Singular object when this object dies.
    bool needcleanup;
    const char *error;  //?< If non-NULL, an error has happened.
    Obj rr;     ///< GAP wrapper of underlying Singular ring
    ring r;     ///< Underlying Singular ring.

    SingObj(Obj input, Obj &extrr, ring &extr) {
        init(input,extrr,extr);
    }

    /// Default constructor for empty object
    SingObj() : gtype(0), needcleanup(false), error(NULL), rr(NULL), r(NULL) {
        obj.Init();
    }

    // This does the actual work
    void init(Obj input, Obj &extrr, ring &extr);

    ~SingObj() {
        cleanup();
    }

    /// Call this to get a pointer to the internal obj structure of type
    /// sleftv if you intend to use the Singular object destructively.
    /// If necessary, copy() is called automatically and any scheduled
    /// cleanup on our side is prevented.
    leftv destructiveuse()  {
        if (!needcleanup) copy();
        needcleanup = false;
        return &obj;
    }

    /// Call this to get a pointer to the internal obj structure of type
    /// sleftv if you intend to use the singular object non-destructively.
    /// No automatic copy() is performed, if cleanup was scheduled it
    /// will be done as scheduled later on.
    leftv nondestructiveuse() {
        return &obj;
    }
    void copy();      ///< Makes a copy if it is not already one
    void cleanup();   ///< Frees object if it was a copy
};

#endif
