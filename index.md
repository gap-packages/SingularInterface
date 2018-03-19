---
layout: default
---

# GAP Package {{site.data.package.name}}

{{site.data.package.abstract}}

The current version of this package is version {{site.data.package.version}}, released on {{site.data.package.date}}.
For more information, please refer to [the package manual]({{site.data.package.doc-html}}).
There is also a [README](README.html) file.

## Dependencies

This package requires GAP version {{site.data.package.GAP}}
as well as Singular 4.0.1 or newer.

{% if site.data.package.needed-pkgs %}
The following other GAP packages are needed:
{% for pkg in site.data.package.needed-pkgs %}
- {% if pkg.url %}<a href="{{ pkg.url }}">{{ pkg.name }}</a> {% else %}{{ pkg.name }} {% endif %}
  {{- pkg.version -}}
{% endfor %}
{% endif %}
{% if site.data.package.suggested-pkgs %}
The following additional GAP packages are not required, but suggested:
{% for pkg in site.data.package.suggested-pkgs %}
- {% if pkg.url %}<a href="{{ pkg.url }}">{{ pkg.name }}</a> {% else %}{{ pkg.name }} {% endif %}
  {{- pkg.version -}}
{% endfor %}
{% endif %}


## Obtaining the SingularInterface source code

The easiest way to obtain SingularInterface is to download the latest version
using one of the download buttons on the left.


If you would like to use the very latest "bleeding edge" version of
SingularInterface, you can also do so, but you will need some additional
tools:

- git
- autoconf
- automake
- libtool

must be installed on your system. You can then
clone the SingularInterface repository as follows:

    git clone https://github.com/gap-system/SingularInterface



## Installing SingularInterface

SingularInterface requires Singular 4.0.1 or later, and that Singular
and GAP are compiled against the exact same version of the GMP
library.

The easiest way to achieve that is to compile Singular yourself,
telling it to link against GAP's version of GMP.

Therefore, usually the first step towards compiling SingularInterface
is to build such a special version of Singular.  The following
instructions should get you going.


1. Fetch the Singular source code. For your convenience, we provide
   two shell scripts which do this for you. If you want to use
   Singular 4.0.1, run
   <pre>./fetchsingular</pre>
   If you want the development version run
   <pre>./fetchsingular.dev</pre>

2. Prepare Singular for compilation. At this point, you need to know
   against which version of GMP your GAP library was linked:
   If it is a GMP version installed globally on your system, simply run:   
   <pre>./configuresingular</pre>
   If it is the version of GMP shipped with GAP, run this instead:
   <pre>./configuresingular --with-gmp=GAPDIR/bin/GAPARCH/extern/gmp</pre>
   where `GAPDIR` should be replaced with the path to your GAP installation,
   and `GAPARCH` by the value of the `GAParch` variable in `GAPDIR/sysinfo.gap`

3. Compile Singular by running
   <pre>./makesingular</pre>

4. Now we turn to SingularInterface. If you are using the git version of
   SingularInterface, you need to setup its build system first.
   To do this, run this command:
   <pre>./autogen.sh</pre>

5. Prepare SingularInterface for compilation, by running
   <pre>
   ./configure --with-gaproot=GAPDIR \
                --with-libSingular=$PWD/singular/dst \
                CONFIGNAME=default64</pre>
   where you should replace `GAP_DIR` as above. If you know what
   you do, you can change your `CONFIGNAME` (but note that
   SingularInterface can only be used with 64 bit versions of GAP).

6. Compile SingularInterface:
   <pre>make</pre>

7. To make sure everything worked, run the test suite
   <pre>make check</pre>


## Contact

You can contact the SingularInterface team by sending an email to

  gapsing AT mathematik DOT uni-kl DOT de

Bug reports and code contributions are highly welcome
and can be submitted via our GitHub
[issues tracker](https://github.com/gap-system/SingularInterface/issues)
respectively via
[pull requests](https://github.com/gap-system/SingularInterface/pulls).


## Author{% if site.data.package.authors.size != 1 %}s{% endif %}
{% for person in site.data.package.authors %}
{% if person.url %}<a href="{{ person.url }}">{{ person.name }}</a>{% else %}{{ person.name }}{% endif %}{% unless forloop.last %}, {% endunless %}{% else %}
{% endfor %}

{% if site.github.issues_url %}
## Feedback

For bug reports, feature requests and suggestions, please use the
[issue tracker]({{site.github.issues_url}}).
{% endif %}
