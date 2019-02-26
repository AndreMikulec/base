

# R for windows `debug` version of package C,C++, and Fortran code on Windows 32/64 [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/AndreMikulec/base)](https://ci.appveyor.com/project/AndreMikulec/base)

NOTE:
I may not be aware of a new release/point_release of R ( e.g. a point release: 3.5.x, 4.0.? . . .).
If so, tell me about it. Email me: Andre_Mikulec@Homail.com.
(I will then run the AppVeyor job to create a new release/point_release.)

If you want the official version of
R for windows, then go here: https://github.com/rwinlib/base

Differences from https://github.com/rwinlib/base follow:

In https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in
added (because 64-bit Windows does not support dwarf-*)
```
G_FLAG = -ggdb3 -Og
```

In https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make 32-bit
```
to
```
make 32-bit DEBUG=T
```

In https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make distribution
```
to
```
make distribution DEBUG=T
```

In https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
after R-ANY.tar.gz extraction of the file src\gnuwin32\fixed\etc\Makeconf
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
In https://github.com/rwinlib/base/blob/master/appveyor.yml
removed sections (Can not access: "C:\jeroen.pfx" ) and performed modifications.

# R for Windows [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/rwinlib/base)](https://ci.appveyor.com/project/jeroen/base)

> Official repository for building R on Windows

This repository is used for daily builds on [appveyor](https://ci.appveyor.com/project/jeroen/base) which get deployed on the [ftp server](https://ftp.opencpu.org).

## Local Requirements

Building R on Windows requires the following tools:

 - Latest [Rtools](https://cran.r-project.org/bin/windows/Rtools/) compiler toolchain
 - Recent [MiKTeX](https://miktex.org/) + packages `fancyvrb`, `inconsolata`, `epsf`, `mptopdf`, `url`
 - [Inno Setup](http://www.jrsoftware.org/isdl.php) to build the installer
 - Perl such as [Strawberry Perl](http://strawberryperl.com/)

The [appveyor-tools.ps1](scripts/appveyor-tool.ps1) powershell can be used for unattended installation of these tools.

## Building

To build manually first clone this repository plus dependencies:

```
git clone https://github.com/rwinlib/base
cd base
git submodule update --init
```

Running `build-r-devel.bat` or `build-r-patched.bat` will automatically download the latest [R-devel.tar.gz](https://stat.ethz.ch/R/daily/R-devel.tar.gz) or [R-patched.tar.gz](https://stat.ethz.ch/R/daily/R-patched.tar.gz) and start the build.

```
build-r-devel.bat
```

The [appveyor.yml](appveyor.yml) file has more details.

## AppVeyor Deployment

This repository is used for daily builds on [appveyor](https://ci.appveyor.com/project/jeroen/base) which get deployed on the [ftp server](https://ftp.opencpu.org). See [appveyor.md](appveyor.md) and [appveyor.yml](appveyor.yml) for configuration details.
