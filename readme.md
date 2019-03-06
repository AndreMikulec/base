

# R for windows `Generic_Debug` and `<CPU optimized>_NoDebug` versions of debug/optimized C, C++, and Fortran on Windows 32/64 [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/AndreMikulec/base)](https://ci.appveyor.com/project/AndreMikulec/base)

The Debug version contains R language debugging symbols.  E.g. `Rf_error` and `Rf_PrintValue`.

See
```
Using gdb to debug R packages with native code
userprimary
```
https://vimeo.com/11937905


One may not be aware of a new release/point_release of R. E.g. a point release is like the  following: 3.5.z or 4.y.z.
If so, inform about it. Email to Andre_Mikulec@Homail.com.
On then should then run the AppVeyor build to create the new release/point_releases.

If one may want the official version of R for windows, then go here: https://github.com/rwinlib/base

## Differences

Differences from the official version of R for windows https://github.com/rwinlib/base follow:

Because 64-bit Windows does not support dwarf-*, in
https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in
added is
```
G_FLAG = -ggdb3 -Og
```

In the Debug variant of R in
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make 32-bit
```
to
```
make 32-bit DEBUG=T
```
In 
the Debug variant of R in
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make distribution
```
to
```
make distribution DEBUG=T
```
In 
https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
after R-ANY.tar.gz extraction of the file `src\gnuwin32\fixed\etc\Makeconf`
using
```
sed -i "s/-gdwarf-2/-ggdb -Og/g" %R_HOME%/src/gnuwin32/fixed/etc/Makeconf
```
changed (on the fly) from
```
DEBUGFLAG=-gdwarf-2
```
to
```
DEBUGFLAG=-ggdb3 -Og
```
In 
https://github.com/rwinlib/base/blob/master/appveyor.yml
removed the signing section (Can not access: "C:\jeroen.pfx").

Note: the *tests* are *not performed.*  This would cause the build to use
up more than one hour of Appveyor allowed time.
The tests had already been done. For the test results see:
```
https://ftp.opencpu.org/current/check.log
https://ftp.opencpu.org/archive/r-patched/svn_number/check.log
https://ftp.opencpu.org/archive/r-release/R-x.y.z/check.log
```
`bin\x64` and `bin\i386` frontend object (.o) files
(with or without debugging symbols) are contained in . . .
```
*-FEobjs64.zip
and
*-FEobjs32.zip
```
These may be useful?

After, one may install the debug version of R.
Next, one may place these object (.o) files in the corresponding directories:
```
bin\x64
and
bin\i386
```
Get Deployments of

 - R-x.y.z-win.exe R installer
 - *-FEobjs64.zip
 - *-FEobjs32.zip

from

https://github.com/AndreMikulec/base/releases
