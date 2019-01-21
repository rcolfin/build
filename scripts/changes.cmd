@ECHO OFF 

SETLOCAL ENABLEDELAYEDEXPANSION

SET "HASH1=%1"
SET "HASH2=%2"
SET "SRCPATH=%3"

PUSHD "!SRCPATH!"
SET "SRCPATH=!CD!"
SET "GITROOT="
FOR /F "tokens=*" %%A IN ('git rev-parse --show-toplevel') DO (
  PUSHD "%%A"
  SET "GITROOT=!CD!"
  POPD
)

SET "CMD=git diff --stat !HASH1! !HASH2! --name-only "!CD!"";
SET "RESULT="
FOR /F "tokens=*" %%A IN ('!CMD!') DO (
  SET "CURRENT=!GITROOT!\%%A"
  SET "CURRENT=!CURRENT:/=\!
  CALL :GETDIR !CURRENT! DIRECTORY
  IF "!DIRECTORY!" NEQ "" (
    SET RESULT[!DIRECTORY!]=1
  )
)

FOR /F "tokens=2 delims=[]" %%B in ('SET RESULT[') DO (
  ECHO %%B
)

POPD
GOTO END

:GETDIR
SET "SRC=%1"
FOR %%I IN ("!SRC!%") DO (
  SET "CURRENT=%%~dI%%~pI"
  PUSHD "!CURRENT!"
  SET "CURRENT=!CD!"
  POPD
  IF "!CURRENT!" EQU "!SRCPATH!" (
    IF EXIST "!SRC!\*" (
      SET "%2=!SRC!"
    )
  ) ELSE (
    CALL :GETDIR !CURRENT! %2
  )
)
GOTO :EOF

:END