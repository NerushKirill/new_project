@echo off
setlocal enabledelayedexpansion

REM Запрос имени проекта
set main_path=%cd%
set project_dir=C:\Users\User\PycharmProjects
set /p project_name="Entetr name youe project: "

REM Создание директории проекта
mkdir %project_dir%\%project_name%
cd %project_dir%\%project_name%

REM Создание виртуального окружения
python -m venv %project_dir%\%project_name%\venv

REM Активация виртуального окружения
call %project_dir%\%project_name%\venv\Scripts\activate

REM Обновление pip и установка poetry
python -m pip install --upgrade pip

mkdir %project_dir%\%project_name%\%project_name%

REM Создание необходимых файлов
type nul > %project_dir%\%project_name%\%project_name%\LICENSE
type nul > %project_dir%\%project_name%\%project_name%\Dockerfile
type nul > %project_dir%\%project_name%\%project_name%\docker-compose.yaml
type nul > %project_dir%\%project_name%\%project_name%\pre-commit.yaml
type nul > %project_dir%\%project_name%\%project_name%\.env.development
type nul > %project_dir%\%project_name%\%project_name%\.env.secret

mkdir %project_dir%\%project_name%\%project_name%\.github\workflows
mkdir %project_dir%\%project_name%\%project_name%\src
mkdir %project_dir%\%project_name%\%project_name%\tests

type nul > %project_dir%\%project_name%\%project_name%\src\__init__.py
type nul > %project_dir%\%project_name%\%project_name%\tests\__init__.py
type nul > %project_dir%\%project_name%\%project_name%\.github\workflows\ci.yaml

REM Копирование файлов
copy %main_path%\files\settings.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\main.py %project_dir%\%project_name%\%project_name%
copy %main_path%\files\Makefile %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.gitignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.dockerignore %project_dir%\%project_name%\%project_name%

REM Деактивация виртуального окружения
deactivate
exit
endlocal
