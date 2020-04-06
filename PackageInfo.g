# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

SetPackageInfo( rec(

PackageName := "SingularInterface",
Subtitle := "A GAP interface to Singular",
Version := "0.8",
Date    := "08/05/2019", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Barakat",
    FirstNames    := "Mohamed",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mohamed.barakat@uni-siegen.de",
    WWWHome       := "https://algebra.mathematik.uni-siegen.de/barakat/",
    PostalAddress := Concatenation(
                       "Department Mathematik\n",
                       "Universität Siegen\n",
                       "Walter-Flex-Straße 3\n",
                       "57072 Siegen\n",
                       "Germany" ),
    Place         := "Siegen",
    Institution   := "Universität Siegen"
  ),
  rec(
    LastName      := "Horn",
    FirstNames    := "Max",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "horn@mathematik.uni-kl.de",
    WWWHome       := "https://www.quendi.de/math",
    PostalAddress := Concatenation(
                       "Fachbereich Mathematik\n",
                       "TU Kaiserslautern\n",
                       "Gottlieb-Daimler-Straße 48\n",
                       "67663 Kaiserslautern\n",
                       "Germany" ),
    Place         := "Kaiserslautern, Germany",
    Institution   := "TU Kaiserslautern"
  ),
  rec(
    LastName      := "Lübeck",
    FirstNames    := "Frank",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "frank.luebeck@@math.rwth-aachen.de",
    WWWHome       := "http://www.math.rwth-aachen.de/~Frank.Luebeck/",
    PostalAddress := Concatenation( [
                       "Frank Lübeck\n",
                       "Lehrstuhl D fuer Mathematik, RWTH Aachen\n",
                       "Templergraben 64\n",
                       "52062 Aachen\n",
                       "Germany" ] ),
    Place         := "Aachen",
    Institution   := "RWTH Aachen University"
  ),
  rec(
    LastName      := "Motsak",
    FirstNames    := "Oleksandr",
    IsAuthor      := true,
    IsMaintainer  := false,
  ),
  rec( 
    LastName      := "Neunhoeffer",
    FirstNames    := "Max",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "max@9hoeffer.de",
  ),
  rec(
    LastName      := "Schönemann",
    FirstNames    := "Hans",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "hannes@mathematik.uni-kl.de",
    WWWHome       := "http://www.mathematik.uni-kl.de/~hannes/",
    PostalAddress := Concatenation( [
                       "Department of Mathematics\n",
                       "University of Kaiserslautern\n",
                       "67653 Kaiserslautern\n",
                       "Germany" ] ),
    Place         := "Kaiserslautern",
    Institution   := "University of Kaiserslautern"
  ),

],

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "deposited"     for packages for which the GAP developers agreed 
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages 
##    "other"         for all other packages
##
# Status := "accepted",
Status := "dev",

##  You must provide the next two entries if and only if the status is 
##  "accepted" because is was successfully refereed:
# format: 'name (place)'
# CommunicatedBy := "Mike Atkinson (St. Andrews)",
#CommunicatedBy := "",
# format: mm/yyyy
# AcceptDate := "08/1999",
#AcceptDate := "",

PackageWWWHome := "https://gap-packages.github.io/SingularInterface",
README_URL     := Concatenation( ~.PackageWWWHome, "/README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL     := Concatenation("https://github.com/gap-packages/SingularInterface/",
                                "releases/download/v", ~.Version,
                                "/SingularInterface-", ~.Version),
ArchiveFormats := ".tar.gz .tar.bz2",
SourceRepository := rec( 
  Type := "git", 
  URL := "https://github.com/gap-packages/SingularInterface"
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),

##  Here you  must provide a short abstract explaining the package content 
##  in HTML format (used on the package overview Web page) and an URL 
##  for a Webpage with more detailed information about the package
##  (not more than a few lines, less is ok):
##  Please, use '<span class="pkgname">GAP</span>' and
##  '<span class="pkgname">MyPKG</span>' for specifing package names.
##  
AbstractHTML := 
  "The <span class=\"pkgname\">SingularInterface</span> package provides\
  a GAP interface to Singular, enabling direct access to the complete\
  functionality of Singular.",

PackageDoc := rec(
  # use same as in GAP
  BookName  := "SingularInterface",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := ~.Subtitle,
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.10",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [
    ["AutoDoc", "2014.03.27"],
    ],
  ExternalConditions := ["Singular 4"]
),

AvailabilityTest := function()
  local path;
    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms("SingularInterface");
    if not "SingularInterface" in SHOW_STAT() and 
       Filename(path, "SingularInterface.so") = fail then
      #Info(InfoWarning, 1, "SingularInterface: compiled kernel module not present.");
      return fail;
    fi;
    return true;
  end,

TestFile := "tst/testall.g",

Keywords := ["Singular", "polynomials", "groebner"],


AutoDoc := rec(
    TitlePage := rec(
        Copyright := Concatenation(
                    "&copyright; 2011-2019 by the &SingularInterface; authors<P/>\n\n",
                    "The &SingularInterface; package is free software;\n",
                    "you can redistribute it and/or modify it under the terms of the\n",
                    "<URL Text=\"GNU General Public License\">https://www.fsf.org/licenses/gpl.html</URL>\n",
                    "as published by the Free Software Foundation; either version 2 of the License,\n",
                    "or (at your option) any later version.\n"
                ),
    )
),


));


