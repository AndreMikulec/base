

# R for windows `Generic_Debug` and `<CPU optimized>_NoDebug` versions of debug/optimized C, C++, and Fortran on Windows 32/64 [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/AndreMikulec/base)](https://ci.appveyor.com/project/AndreMikulec/base)

## R Build Variants

Two build of R exists: `Generic_Debug` and `<CPU optimized>_NoDebug`.

The Debug version contains R language debugging symbols.  E.g. if the debug target in Rterm.exe and the package DLL has been loaded,
then when debugging the package DLL, the symbols `Rf_error` and `Rf_PrintValue` are available.

See the video:
```
Using gdb to debug R packages with native code
userprimary
```
https://vimeo.com/11937905

The CPU Optimized version is built using custom optimization flag(s) available in Rtools 35 (and later).
Debugging symbols are `not` included.

## Available Point Releases

One may not be aware of a new release/point_release of R. E.g. a point release is like the  following: 3.5.z or 4.y.z.
If so, inform one about it. Email to Andre_Mikulec@Homail.com.
One then should then run the AppVeyor build to create the new release/point_releases.

If one may want the official version of R for windows, then one may go here: https://github.com/rwinlib/base

## Differences

Differences from the official version of R for windows https://github.com/rwinlib/base follow:

Because 64-bit Windows does not support dwarf-*, in the
https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in file
added is
```
G_FLAG = -ggdb3 -Og
```

In the Debug variant of R in the
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat file
changed is from
```
make 32-bit
```
to
```
make 32-bit DEBUG=T
```

In the Debug variant of R in the
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat file
changed is from
```
make distribution
```
to
```
make distribution DEBUG=T
```


In the
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat file
after any R-ANY.tar.gz extraction of the file `src\gnuwin32\fixed\etc\Makeconf`
using
```
sed -i "s/-gdwarf-2/-ggdb -Og/g" %R_HOME%/src/gnuwin32/fixed/etc/Makeconf
```
changed is (on the fly) from
```
DEBUGFLAG=-gdwarf-2
```
to
```
DEBUGFLAG=-ggdb3 -Og
```
Note: after the installation of R, upon a package install from source,
that contains a source file in the sub-folder `\src`, the following message may occur:
```
make: Warning: File '. . . /etc/i386/Makeconf' has modification time zzzzz s in the future
```
The reason for this message is the following.  Early in the Appveyor build job, the time zone was changed to UTC.
After the time zone change, the file Makeconf was modified.  The time zone is not stored in OS metadata about a file.
This message can be ignored.  This message will *no longer display* in zzzzz/3600 hours.


In the
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat file
using
```
sed -i "s/\(.*\)/\1 %MARCHMTUNENAME% %DIST_BUILD%/g" %R_HOME%/VERSION-NICK
```
changed is (on the fly)  from
```
VERSION-NICK
```
to
```
VERSION-NICK %MARCHMTUNENAME% %DIST_BUILD%
```


In the
https://github.com/rwinlib/base/blob/master/appveyor.yml file
removed the signing section. The file `C:\jeroen.pfx` is not availble.

Note: the *tests* are *not performed.*  These tests would cause any Appveyor build-job to use
over one hour of allowed Appveyor build-job allowed time.
The tests had already been done! To see the test results view:
```
https://ftp.opencpu.org/current/check.log
https://ftp.opencpu.org/archive/r-patched/svn_number/check.log
https://ftp.opencpu.org/archive/r-release/R-x.y.z/check.log
```


From `R-source-win64\src\gnuwin32\front-ends` and `R-source-win32\src\gnuwin32\front-ends` object (.o) files
(with or without debugging symbols) are contained in . . .
```
*-FEobjs64.zip
and
*-FEobjs32.zip
```
These may be useful?

After one may install the debug version of R.
One may then place these object (.o) files in the corresponding directories:
```
bin\x64
and
bin\i386
```

## Build deployments of R: `Generic_Debug` and `<CPU optimized>_NoDebug`.

Get Deployments of

 - R-x.y.z-win.exe R installer
 - *-FEobjs64.zip
 - *-FEobjs32.zip

from

https://github.com/AndreMikulec/base/releases
