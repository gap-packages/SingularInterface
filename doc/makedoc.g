LoadPackage("gapdoc");;

MakeGAPDocDoc( ".", "libsing", [ "../PackageInfo.g" ], "libsing" );;


LoadPackage( "GAPDoc" );

# Determine GAPROOT
if IsRecord(GAPInfo.SystemEnvironment) and
   IsBound(GAPInfo.SystemEnvironment.GAPROOT) then
	GAPROOT:=GAPInfo.SystemEnvironment.GAPROOT;
else
	GAPROOT:="../../..";
fi;
Display(GAPROOT);

# Some settings
SetGapDocLaTeXOptions( "utf8" );

# Update bib
#bib := ParseBibFiles( "doc/libsing.bib" );
#WriteBibXMLextFile( "doc/libsing.bib.xml", bib );

# List of files to scan
files := [ "../PackageInfo.g" ];;

HasSuffix := function(list, suffix)
  local n; n := Length(list);
  return Length(list) >= Length(suffix) and list{[n-Length(suffix)+1..n]} = suffix;
end;

dir:=Directory("../lib");;
candidates := Filtered(DirectoryContents(dir), fname -> HasSuffix(fname, ".gd"));
dir := Directory(dir);
Append(files, List(candidates, fname -> Filename(dir, fname)));

# Generate the documentation
main := "libsing";;
bookname := "libsing";;
MakeGAPDocDoc( ".", main, files, bookname, GAPROOT, "MathJax" );;

# Copy over the style files (only available in newer GAPDoc versions)
if IsBound(CopyHTMLStyleFiles) then
	CopyHTMLStyleFiles(".");
fi;
