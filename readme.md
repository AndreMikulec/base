

# R for windows `debug` version of package C,C++, and Fortran code on Windows 32/64

NOTE:
I may not be aware of a new release/point_release of R ( e.g. a point release: 3.5.x, 4.0.? . . .).
If so, tell me about it. Email me: Andre_Mikulec@Homail.com.
(I will then run the AppVeyor job to create a new release/point_release.)

If you want the official version of
R for windows, then go here: https://github.com/rwinlib/base

Differences from https://github.com/rwinlib/base follow:

In https://github.com/AndreMikulec/base/blob/master/files/MkRules.local.in
added (because 64bit Windows does not support dwarf-*)
```
G_FLAG = -ggdb3 -Og
```

In https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make 32-bit > %BUILDDIR%/32bit.log 2>&1
```
to
```
make 32-bit DEBUG=T > %BUILDDIR%/32bit.log 2>&1
```

In https://github.com/AndreMikulec/base/blob/master/scripts/build.bat
changed from
```
make distribution > %BUILDDIR%/distribution.log 2>&1
```
to
```
make distribution DEBUG=T > %BUILDDIR%/distribution.log 2>&1
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
removed sections (Can not access: "C:\jeroen.pfx" )
```
  PfxUri:
    secure: z+vP1iY4odY07BV7v+yfuA2MBKQFFLGokZoefPhz22evsMT/KnwtB4NgcYNLJheI
  CertPassword:
    secure: nwSwtaLCl6Xo5sfqKLvO30aFFGCgjGJ2GKTqS33zkJg=
  SignTool: C:\Program Files (x86)\Windows Kits\8.1\bin\x64\signtool.exe
  CertKit: C:\Program Files (x86)\Windows Kits\10\App Certification Kit\appcert.exe
  KeyFile: C:\jeroen.pfx
```
```
after_build:
artifacts:
on_finish:
deploy:
```
then replaced the `deploy` section to
```
deploy:
  release: $(APPVEYOR_PROJECT_SLUG)_$(appveyor_build_version)_%archive%_%target%_%revision%
  provider: GitHub
  auth_token:
    secure: KzS1DumC2yBg2LGN9x3AemHFOjAdp+rD58rW5aGGpwW4Pfdwdm7AmRpYKprPY8Gs
  artifact: $(APPVEYOR_PROJECT_SLUG)_Dist_%archive%_%target%_%revision%
  draft: false
  prerelease: false
  on:
    branch: master
    # I do not care about tags
    appveyor_repo_tag: false

artifacts:
  - path: dist
    name: $(APPVEYOR_PROJECT_SLUG)_Dist_%archive%_%target%_%revision%
```

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
