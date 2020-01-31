
# R for windows `Generic_Debug` and `<CPU optimized>_NoDebug` versions of debug/optimized for C, C++, and Fortran on 32/64 bit Windows
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/AndreMikulec/base)](https://ci.appveyor.com/project/AndreMikulec/base)

## AppVeyor R Build Variants

Two build of R exists: `Generic_Debug` and `<CPU optimized>_NoDebug`.

### Generic_Debug Build

The Debug version `Generic_Debug` contains R language debugging symbols.  E.g. if the debug target is Rterm.exe and the package DLL has been loaded, then when debugging the package DLL, the symbols `Rf_error` and `Rf_PrintValue` are available.

See the video:
```
Using gdb to debug R packages with native code
userprimary
```
https://vimeo.com/11937905

### CPU Optimized NoDebug Build

The CPU Optimized version `<CPU optimized>_NoDebug` is built using custom optimization flag(s) available in Rtools 35 (and later).
Debugging symbols are `not` included.

## Available Point Releases

One may not be aware of a new release/point_release of R. E.g. a point release is like the  following: 3.6.z or 4.y.z.
If so, inform one about it. Email to Andre_Mikulec@Homail.com.
One then should then run the AppVeyor build to create the new release/point_releases.

## Other: Official-Version/Patched-snapshot/Build-of-the-development (OPB) version of R

### Official Version of R

If one may want the official version of R for windows, then one may go to any one of here: https://cran.r-project.org/bin/windows/base/, https://ftp.opencpu.org/archive/r-release/, or https://github.com/rwinlib/base/releases.

### Patched snapshot version of R

If one may want the Patched snapshot build of R for windows, then one may go here: https://cran.r-project.org/bin/windows/base/rpatched.html.

### Build-of-the-development version of R

If one may want the Build of the development version (which will eventually become the next major release) of R for windows, then one may go here: https://cran.r-project.org/bin/windows/base/rdevel.html.

## Differences From the OPB version of R

### Major version of Inno Setup is explicitly chosen

Configuration is in the files: appveyor.yml, MkRules.local.in, and build.bat.

From rwinlib/base (May 5, 2019), see this commit.
This commit was never applied to AndreMikulec/base.
https://github.com/rwinlib/base/commit/8e4eeb2e44bf23764ffdf11e1366f01140829179

### Debugging Symbols

From the OPB version of R for windows https://github.com/rwinlib/base differences (in here) follow:

Because 64-bit Windows does not support dwarf-*, in the
file https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in, added, is
```
G_FLAG = -ggdb3 -Og
```

In the Debug variant of R `Generic_Debug` in the
file https://github.com/AndreMikulec/base/blob/master/scripts/build.bat, changed, is from
```
make 32-bit
```
to
```
make 32-bit DEBUG=T
```

In the Debug variant of R `Generic_Debug` in the
file https://github.com/AndreMikulec/base/blob/master/scripts/build.bat, changed, is from
```
make distribution
```
to
```
make distribution DEBUG=T
```

Again, because 64-bit Windows does not support dwarf-*, in the
file https://github.com/AndreMikulec/base/blob/master/scripts/build.bat, after
any R-ANY.tar.gz extraction of the file `src\gnuwin32\fixed\etc\Makeconf`
using
```
sed -i "s/-gdwarf-2/-ggdb -Og/g" %R_HOME%/src/gnuwin32/fixed/etc/Makeconf
```
changed, is from
```
DEBUGFLAG=-gdwarf-2
```
to
```
DEBUGFLAG=-ggdb3 -Og
```

### EOPTS is explicity chosen

Because, of the various custom march/mtune runs of these AppVeyor build-jobs
and the changing of march/mtune

In the 
file https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in 
```
EOPTS = -mtune=generic
```
is retained whereas in the OPB version of R
```
# EOPTS = -mtune=generic
```
is explicity removed (commented out).

### -march/-mtune in the Version Nickname

In the
file https://github.com/AndreMikulec/base/blob/master/scripts/build.bat, using
```
sed -i "s/\(.*\)/\1 %MARCHMTUNENAME% %DIST_BUILD%/g" %R_HOME%/VERSION-NICK
```
changed, is from
```
VERSION-NICK
```
to
```
VERSION-NICK %MARCHMTUNENAME% %DIST_BUILD%
```

### No Code Signing

In the
file https://github.com/rwinlib/base/blob/master/appveyor.yml, removed, is the signing section. The file `C:\jeroen.pfx` is not available.

### R Tests are Skipped 

The *tests* are *not performed.*  These tests would/may cause any Appveyor build-job to use
over one hour of allowed Appveyor build-job allowed time.
However, the tests had already been done! To see the test results view:
```
https://ftp.opencpu.org/current/check.log
https://ftp.opencpu.org/archive/r-patched/svn_number/check.log
https://ftp.opencpu.org/archive/r-release/R-x.y.z/check.log
```
### make: Warning: File '. . . /etc/i386/Makeconf' has modification time zzzzz s in the future

Note, after the installation of R, upon a package install from source,
that contains a source file in the sub-folder `\src`, the following message may occur:
```
make: Warning: File '. . . /etc/i386/Makeconf' has modification time zzzzz s in the future
```
The reason for this message is the following.  Early in the Appveyor build job, the time zone was changed to UTC.  After the time zone change, the file Makeconf was modified ( above by 'sed').  The time zone is not stored in OS metadata about a file. This message can be ignored.  This message will *no longer display* in zzzzz/3600 hours.

### Object Files (.o) are Distributed

From the directories `R-source-win64\src\gnuwin32\front-ends` and `R-source-win32\src\gnuwin32\front-ends` object (.o) files (with or without debugging symbols) are contained in . . .
```
*-FEobjs64.zip
and
*-FEobjs32.zip
```
These may be useful?

After, one may install the debug version of R `Generic_Debug`.
One may then place these object (.o) files in the correct directories:
```
bin\x64
and
bin\i386
```

## AppVeyor Build Deployments of R: `Generic_Debug` and `<CPU optimized>_NoDebug`.

Located near the top of
the page https://github.com/AndreMikulec/base/releases,
one may get deployments from one of the `top` (recent) build-jobs.

Expand the asset drop down arrow: [v}Asset 
and download the
```
base_*...*.zip
```
file that contains the files:

 - R-x.y.z[archive]-win.exe R installer
 - *-FEobjs64.zip
 - *-FEobjs32.zip


