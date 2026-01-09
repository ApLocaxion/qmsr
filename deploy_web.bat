@echo off
setlocal enabledelayedexpansion

set FLUTTER_BIN=C:\flutter\bin\flutter
set BASE_HREF=/qmsr/
set COMMIT_MESSAGE=Update web build

if not exist "%FLUTTER_BIN%" (
  echo Flutter not found at %FLUTTER_BIN%.
  exit /b 1
)

echo Running flutter pub get...
"%FLUTTER_BIN%" pub get || exit /b 1

echo Building web with base href %BASE_HREF%...
"%FLUTTER_BIN%" build web --base-href %BASE_HREF% || exit /b 1

echo Syncing build/web to docs...
robocopy build\web docs /MIR
if %errorlevel% GEQ 8 (
  echo Robocopy failed with errorlevel %errorlevel%.
  exit /b %errorlevel%
)

echo Checking git status...
git add -A
git diff --cached --quiet
if %errorlevel%==0 (
  echo No changes to commit.
  exit /b 0
)

echo Committing and pushing...
git commit -m "%COMMIT_MESSAGE%" || exit /b 1
git push || exit /b 1

echo Done.
