echo on
::set target=R-devel.tar.gz
set TARBALL=%1
if not exist "%TARBALL%" (
echo File not found: %TARBALL% && exit /b 1
)

REM
REM  Andre Mikulec
REM
set

::set WIN=32
::set WIN=64
set WIN=%2

::globals
set STARTDIR=%CD%
set SOURCEDIR=%~dp0..
mkdir ..\BUILD
cd ..\BUILD
set BUILDDIR=%CD%

echo SOURCEDIR: %SOURCEDIR%
echo BUILDDIR: %BUILDDIR%

:: Set name of target
set VERSION=%TARBALL:~0,-7%
set R_NAME=%VERSION%-win%WIN%
set R_HOME=%BUILDDIR%\%R_NAME%
set TMPDIR=%TEMP%

:: For multilib build
set HOME32=%BUILDDIR%\%VERSION%-win32

:: Add rtools executables in path
set PATH=C:\rtools\bin;%PATH%

:: Copy sources
rm -Rf %R_NAME%
mkdir %R_NAME%

:: Needed to fix tar symlinks
set MSYS=winsymlinks:lnk
tar -xf %SOURCEDIR%/%TARBALL% -C %R_NAME% --strip-components=1

:: Temp workaround for broken R-devel symlink tests
::set MSYS=
::tar -xf %SOURCEDIR%/%TARBALL% -C %R_NAME% --strip-components=1

REM
REM  Andre Mikulec
REM
REM Basically MkRules.dist is aa SAMPLE.
REM Later ONE manully copies this file  OVER to 
REM become the NEW MkRules.local.  Next, ONE customizes MkRules.local.
REM https://cran.r-project.org/doc/manuals/r-patched/R-admin.html
REM 
REM additional optimization flags (e.g. -mtune=native for a private build)
REM ARE WORDS FOUND IN src/gnuwin32/MkRules.dist
REM
REM echo BEGIN - BEFORE custom EOPTS - MkRules.dist
REM echo type %R_HOME%\src\gnuwin32\MkRules.dist
REM type %R_HOME%\src\gnuwin32\MkRules.dist                2> nul
REM echo AFTER - BEFORE custom EOPTS - MkRules.dist

REM MkRules.rules is the DEFAULT
REM
REM What is the purpose of MkRules.local.in and MkRules.rules ?
REM https://github.com/rwinlib/base/issues/25
REM
echo BEGIN - BEFORE custom EOPTS - MkRules.rules
echo type %R_HOME%\src\gnuwin32\MkRules.rules
type %R_HOME%\src\gnuwin32\MkRules.rules               2> nul
echo AFTER - BEFORE custom EOPTS - MkRules.rules

REM MkRules.local.in gets copied into MkRules.local after some substitutions
REM
REM What is the purpose of MkRules.local.in and MkRules.rules ?
REM https://github.com/rwinlib/base/issues/25
REM
echo BEGIN - BEFORE custom EOPTS - MkRules.local
echo type %R_HOME%\src\gnuwin32\MkRules.local
type %R_HOME%\src\gnuwin32\MkRules.local               2> nul
echo AFTER - BEFORE custom EOPTS - MkRules.local

echo BEGIN - BEFORE custom EOPTS - MkRules.local.in
echo type %SOURCEDIR%\files\MkRules.local.in
type %SOURCEDIR%\files\MkRules.local.in                2> nul
echo AFTER - BEFORE custom EOPTS - MkRules.local.in

set XR_HOME=%R_HOME:\=/%
set XHOME32=%HOME32:\=/%
sed -e "s|@win@|%WIN%|" -e "s|@home@|%XR_HOME%|" -e "s|@home32@|%XHOME32%|" -e "s|@inno@|%innosetup%|"^
	      %SOURCEDIR%\files\MkRules.local.in > %R_HOME%/src/gnuwin32/MkRules.local

echo BEGIN - AFTER custom EOPTS - MkRules.local
echo type %R_HOME%\src\gnuwin32\MkRules.local
type %R_HOME%\src\gnuwin32\MkRules.local               2> nul
echo AFTER - AFTER custom EOPTS - MkRules.local

REM a VARIABLE if it has not been set yet
REM could overrided  by defining that VARIABLE in MkRules.local
REM
REM This is standard gnu make syntax that sets a variable if it has not been set yet.
REM  ?=
REM
REM Andre
REM
REM The case seems that in MkRules.local a hard coded override VALUE 
REM that is a VALUE without the (?=) 
REM is the FINAL value (overriding any previous values))
REM
REM What is the purpose of MkRules.local.in and MkRules.rules ?
REM https://github.com/rwinlib/base/issues/25
REM
REM clue from . . .
REM https://github.com/wch/r-source/search?q=EOPTS&unscoped_q=EOPTS
REM
REM Andre
REM
REM The manual always explains that MkRules.local is where my CUSTOM changes must end up.
REM https://cran.r-project.org/doc/manuals/r-patched/R-admin.html
REM
echo BEGIN - BEFORE custom EOPTS - MkRules.local
echo type %R_HOME%\src\gnuwin32\MkRules.local
type %R_HOME%\src\gnuwin32\MkRules.local               2> nul
echo AFTER - BEFORE custom EOPTS - MkRules.local
REM
sed -i -e 's/^# EOPTS =.*/EOPTS =/' -e 's/^EOPTS =.*/EOPTS = %MARCHMTUNE%/' %R_HOME%/src/gnuwin32/MkRules.local

echo BEGIN - AFTER custom EOPTS - MkRules.local
echo type %R_HOME%\src\gnuwin32\MkRules.local
type %R_HOME%\src\gnuwin32\MkRules.local               2> nul
echo AFTER - AFTER custom EOPTS - MkRules.local

echo BEGIN  - BEFORE Custom  DEBUGFLAG - Makeconf
echo %R_HOME%/src/gnuwin32/fixed/etc/Makeconf
type %R_HOME%/src/gnuwin32/fixed/etc/Makeconf         2> nul
echo END  - BEFORE Custom  DEBUGFLAG - Makeconf

REM Because Microsoft Corporation
REM does not support dwarf debugging symbols on 64 bit Windows
REM
REM ifdef DEBUG
REM   DLLFLAGS=
REM   DEBUGFLAG=-gdwarf-2
REM else
REM   DLLFLAGS=-s
REM   DEBUGFLAG=
REM endif
REM https://github.com/wch/r-source/blob/R-3-6-branch/src/gnuwin32/fixed/etc/Makeconf
REM
REM NOTE MkRules.local (in the MAKING process) is fed into etc/Makeconf
REM
REM sed -e . MkRules VARIABLE SUBSTITUTION . etc/Makeconf > ../../../etc/i386/Makeconf
REM
sed -i "s/-gdwarf-2/-ggdb -Og/g" %R_HOME%/src/gnuwin32/fixed/etc/Makeconf

echo BEGIN  - AFTER Custom  DEBUGFLAG - Makeconf
echo %R_HOME%/src/gnuwin32/fixed/etc/Makeconf
type %R_HOME%/src/gnuwin32/fixed/etc/Makeconf    2> nul
echo END  - AFTER Custom  DEBUGFLAG - Makeconf

:: Copy libraries
cp -R %SOURCEDIR%\libcurl %R_HOME%\libcurl
cp -R %SOURCEDIR%\Tcltk\Tcl%WIN% %R_HOME%\Tcl
cp -R %SOURCEDIR%\baselibs %R_HOME%\extsoft
cp %SOURCEDIR%\files\curl-ca-bundle.crt %R_HOME%\etc\curl-ca-bundle.crt

:: Temporary fix for cairo stack
mkdir %BUILDDIR%\%R_NAME%\cairo
cp -R %SOURCEDIR%\cairo\lib\x64 %R_HOME%\cairo\win64
cp -R %SOURCEDIR%\cairo\lib\i386 %R_HOME%\cairo\win32
xcopy /s "%SOURCEDIR%\cairo\include\cairo" "%R_HOME%\cairo\win32"
xcopy /s "%SOURCEDIR%\cairo\include\cairo" "%R_HOME%\cairo\win64"

:: Mark output as experimental
::sed -i "s/Under development (unstable)/EXPERIMENTAL/" %R_HOME%/VERSION
::echo cat('R-experimental') > %R_HOME%/src/gnuwin32/fixed/rwver.R
::sed -i "s|Unsuffered Consequences|Blame Jeroen|" %R_HOME%/VERSION-NICK

REM
REM  Andre Mikulec
REM
sed -i "s/\(.*\)/\1 %MARCHMTUNENAME% %DIST_BUILD%/g" %R_HOME%/VERSION-NICK
type %R_HOME%\VERSION-NICK

::echo PATH="C:\Rtools\bin;${PATH}" > %R_HOME%/etc/Renviron.site

:: apply local patches
cd %R_HOME%
patch -p1 -i %SOURCEDIR%\patches\shortcut.diff

:: Remove conditioning when r-devel switched to new toolchain
if "%archive%" == "r-devel" (
	echo "Skipping cairo patch"
) else (
	echo archive: %archive%
	patch -p1 -i %SOURCEDIR%\patches\cairo.diff
)

:: Switch dir
cd %R_HOME%/src/gnuwin32

:: Add 'make' to the user path
:: sed -i "s|ETC_FILES = Rprofile.site|ETC_FILES = Renviron.site Rprofile.site|" installer/Makefile

:: Allow overriding LOCAL_SOFT variable at runtime
set LOCAL_SOFT=%XR_HOME%/extsoft
sed -i "s|LOCAL_SOFT =|#LOCAL_SOFT|" fixed/etc/Makeconf
::sed -i "s|LOCAL_SOFT =|LOCAL_SOFT ?= \$(R_USER)/R/\$(COMPILED_BY)|" fixed/etc/Makeconf

:: Download 'extsoft' directory
:: make rsync-extsoft
echo %R_HOME%\src\gnuwin32 directory BEFORE Build 32bit R version only
dir %R_HOME%\src\gnuwin32
echo BUILD directory BEFORE Build 32bit R version only
dir %BUILDDIR%
:: Build 32bit R version only
IF "%WIN%"=="32" (
REM
REM  Andre Mikulec
REM
make %MAKE_32BIT% 2>&1 | tee %BUILDDIR%/32bit.log
if %errorlevel% neq 0 (
	echo ERROR: 'make 32-bit' failure! Inspect 32bit.log for details.
	exit /b 2
) else (
	cd %SOURCEDIR%
	echo make 32-bit complete!
	exit /b 0
)
)
echo %R_HOME%\src\gnuwin32 directory AFTER  Build 32bit R version only
echo %R_HOME%\src\gnuwin32 directory BEFORE Build 64bit version + installer
dir %R_HOME%\src\gnuwin32
echo BUILD directory AFTER  Build 32bit R version only
echo BUILD directory BEFORE Build 64bit version + installer
dir %BUILDDIR%

:: Build 64bit version + installer
REM
REM  Andre Mikulec
REM
make %MAKE_DISTRIBUTION% 2>&1 | tee %BUILDDIR%/distribution.log
if %errorlevel% neq 0 (
	echo ERROR: 'make distribution' failure! Inspect distribution.log for details.
	exit /b 2
)
echo make distribution complete!
echo %R_HOME%\src\gnuwin32 directory AFTER Build 64bit version + installer
dir %R_HOME%\src\gnuwin32
echo BUILD directory AFTER Build 64bit version + installer
dir %BUILDDIR%

REM
REM  Andre Mikulec
REM
REM MY(Andre Miklec) total build time takes OVER one hour, so "times out"
REM base-prerelease/R-latest.tar.gz
REM
REM 64 minutes ( so J Ooms has more time allowed by Appveyor )
REM REM https://ci.appveyor.com/project/jeroen/base
REM
REM MY total time takes 40 mintues
REM R-Devel.tar.gz
REM 
REM total time 73 minutes ( so J Ooms has more time allowed by Appveyor )
REM https://ci.appveyor.com/project/jeroen/base
REM
REM make check-all 2>&1 | tee %BUILDDIR%/check.log
REM if %errorlevel% neq 0 (
REM   echo ERROR: 'make check-all' failure! Inspect check.log for details.
REM   type %builddir%\check.log
REM   exit /b 2
REM )
REM echo %R_HOME%\src\gnuwin32 directory AFTER "make check-all"
dir %R_HOME%\src\gnuwin32
echo BUILD directory AFTER "make check-all"
dir %BUILDDIR%

:: Get the actual version name
call %R_HOME%\src\gnuwin32\cran\target.cmd

:: Get the SVN revision number
set /p SVNSTRING=<%R_HOME%/SVN-REVISION
set REVISION=%SVNSTRING:~10%

:: Copy files to ship in the distribution
cd %BUILDDIR%
cp %R_HOME%/SVN-REVISION SVN-REVISION.%target%
cp %R_HOME%/src/gnuwin32/cran/%target%-win.exe .
cp %R_HOME%/src/gnuwin32/cran/md5sum.txt md5sum.txt.%target%
cp %R_HOME%/src/gnuwin32/cran/NEWS.%target%.html .
cp %R_HOME%/src/gnuwin32/cran/CHANGES.%target%.html .
cp %R_HOME%/src/gnuwin32/cran/README.%target% .
cp %R_HOME%/src/gnuwin32/cran/target.cmd .

:: Infer release from target.cmd, for example "R-3.4.2-patched"
IF "%target:~-5,5%"=="devel" (
set reltype=devel
) ELSE IF "%target:~-7,7%"=="patched" (
set reltype=patched
) ELSE IF "%target:~-2,2%"=="rc" (
set reltype=patched
) ELSE IF "%target:~-5,5%"=="alpha" (
set reltype=patched
) ELSE IF "%target:~-4,4%"=="beta" (
set reltype=patched
) ELSE IF "%target:~0,3%"=="R-3" (
set reltype=release
) ELSE (
echo "Unknown target type: %target%"
exit /b 1
)

:: Symlink (disabled because doesn't survive sftp)
:: ln -s %target%-win.exe R-%reltype%.exe
echo %target%-win.exe > R-%reltype%.txt

:: Webpages to ship on CRAN
IF "%reltype%"=="devel" (
cp %R_HOME%/src/gnuwin32/cran/rdevel.html .
) ELSE IF "%reltype%"=="patched" (
cp %R_HOME%/src/gnuwin32/cran/rpatched.html .
cp %R_HOME%/src/gnuwin32/cran/rtest.html .
) ELSE IF "%reltype%"=="release" (
cp %R_HOME%/src/gnuwin32/cran/index.html .
cp %R_HOME%/src/gnuwin32/cran/md5sum.txt .
cp %R_HOME%/src/gnuwin32/cran/rw-FAQ.html .
cp %R_HOME%/src/gnuwin32/cran/release.html .
set REVISION=%target%
)
echo BUILD\src\gnuwin32\cran directory AFTER Webpages to ship on CRAN
dir %R_HOME%\src\gnuwin32\cran
echo BUILD\src\gnuwin32 directory AFTER Webpages to ship on CRAN
dir %R_HOME%\src\gnuwin32

:: Done
cd %STARTDIR%
