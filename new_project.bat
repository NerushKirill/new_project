@echo off
setlocal enabledelayedexpansion

REM Project name prompt
set main_path=%cd%
set project_dir=Z:\Projects
set /p project_name="Enter name youe project: "

REM Creating a Project Directory
mkdir %project_dir%\%project_name%
cd %project_dir%\%project_name%

REM Creating a virtual environment
python -m venv %project_dir%\%project_name%\venv

REM Activating the virtual environment
call %project_dir%\%project_name%\venv\Scripts\activate

REM Updating pip and installing poetry
python -m pip install --upgrade pip
pip install poetry

mkdir %project_dir%\%project_name%\%project_name%

REM Creating the necessary files
type nul > %project_dir%\%project_name%\%project_name%\LICENSE
type nul > %project_dir%\%project_name%\%project_name%\pre-commit.yml
type nul > %project_dir%\%project_name%\%project_name%\.env.secret

mkdir %project_dir%\%project_name%\%project_name%\.github\workflows
mkdir %project_dir%\%project_name%\%project_name%\src
mkdir %project_dir%\%project_name%\%project_name%\tests

type nul > %project_dir%\%project_name%\%project_name%\.github\workflows\ci.yml
type nul > %project_dir%\%project_name%\%project_name%\src\__init__.py
type nul > %project_dir%\%project_name%\%project_name%\tests\__init__.py

REM Copying files
copy %main_path%\files\commands %project_dir%\%project_name%

copy %main_path%\files\settings.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\main.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\Makefile %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.env.development %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.gitignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.dockerignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\Dockerfile %project_dir%\%project_name%\%project_name%
copy %main_path%\files\docker-compose.yml %project_dir%\%project_name%\%project_name%
copy %main_path%\files\README.md %project_dir%\%project_name%\%project_name%

REM Create pyproject.toml
(
echo [tool.poetry]
echo name = "%project_name%"
echo version = "0.1.0"
echo description = ""
echo authors = ["Kirill Nerush <nerush.kirill@gmail.com>"]
echo readme = "README.md"
echo.
echo [tool.poetry.dependencies]
echo python = "^3.11"
echo pydantic-settings = "^2.1.0"
echo.
echo.
echo [build-system]
echo requires = ["poetry-core"]
echo build-backend = "poetry.core.masonry.api"
) > %project_dir%\%project_name%\%project_name%\pyproject.toml

cd %project_dir%\%project_name%\%project_name%
poetry install

set /p project_name="Succes. Enter to exit."

REM Deactivating a virtual environment
deactivate
exit
endlocal
