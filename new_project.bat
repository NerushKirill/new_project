@echo off
setlocal enabledelayedexpansion

REM Project name prompt
set main_path=%cd%
set project_dir=Z:\Projects
set /p project_name="Entetr name youe project: "

REM Creating a Project Directory
mkdir %project_dir%\%project_name%
cd %project_dir%\%project_name%

REM Creating a virtual environment
python -m venv %project_dir%\%project_name%\venv

REM Activating the virtual environment
call %project_dir%\%project_name%\venv\Scripts\activate

REM Updating pip and installing poetry
python -m pip install --upgrade pip

mkdir %project_dir%\%project_name%\%project_name%

REM Creating the necessary files
type nul > %project_dir%\%project_name%\%project_name%\README.md
type nul > %project_dir%\%project_name%\%project_name%\LICENSE
type nul > %project_dir%\%project_name%\%project_name%\pre-commit.yml
type nul > %project_dir%\%project_name%\%project_name%\.env.development
type nul > %project_dir%\%project_name%\%project_name%\.env.secret

mkdir %project_dir%\%project_name%\%project_name%\.github\workflows
mkdir %project_dir%\%project_name%\%project_name%\src
mkdir %project_dir%\%project_name%\%project_name%\tests

type nul > %project_dir%\%project_name%\%project_name%\src\__init__.py
type nul > %project_dir%\%project_name%\%project_name%\tests\__init__.py
type nul > %project_dir%\%project_name%\%project_name%\.github\workflows\ci.yml

REM Copying files
copy %main_path%\files\command.sh %project_dir%\%project_name%
copy %main_path%\files\settings.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\main.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\Makefile %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.gitignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.dockerignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\Dockerfile %project_dir%\%project_name%\%project_name%
copy %main_path%\files\docker-compose.yml %project_dir%\%project_name%\%project_name%

REM Deactivating a virtual environment
deactivate
exit
endlocal
