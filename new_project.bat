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
copy %main_path%\files\.env.development %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.gitignore %project_dir%\%project_name%\%project_name%
copy %main_path%\files\.dockerignore %project_dir%\%project_name%\%project_name%
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
echo.[tool.poetry.group.dev.dependencies]
echo.
echo.
echo [tool.mypy]
echo python_version = 3.11
echo plugins = "sqlalchemy.ext.mypy.plugin"
echo ignore_missing_imports = true
echo.
echo [[tool.mypy.overrides]]
echo module = "*.migrations.*"
echo ignore_errors = true
echo.
echo [tool.ruff]
echo # https://beta.ruff.rs/docs/configuration/
echo select = ['E', 'W', 'F', 'I', 'B', 'C4', 'ARG', 'SIM']
echo ignore = ['W291', 'W292', 'W293']
echo.
echo [build-system]
echo requires = ["poetry-core"]
echo build-backend = "poetry.core.masonry.api"
) > %project_dir%\%project_name%\%project_name%\pyproject.toml


REM Add to Dockerfile
(
echo # Default to the latest slim version of Python
echo ARG PYTHON_IMAGE_TAG=3.11.8-alpine3.19
echo.
echo # POETRY BASE IMAGE - Provides environment variables for poetry
echo FROM python:${PYTHON_IMAGE_TAG} AS python-base
echo.
echo # POETRY BUILDER IMAGE - Installs Poetry and dependencies
echo FROM python-base AS python-poetry-builder
echo.
echo RUN pip install --upgrade pip
echo RUN apk add gcc musl-dev libffi-dev
echo RUN pip install poetry
echo.
echo # POETRY RUNTIME IMAGE - Copies the poetry installation into a smaller image
echo FROM python-poetry-builder AS python-poetry
echo COPY --from=python-poetry-builder $POETRY_HOME $POETRY_HOME
echo.
echo # MY PROJECTS
echo FROM python-poetry AS %project_name%
echo.
echo WORKDIR /%project_name%
echo COPY . /%project_name%
echo.
echo "RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi --without dev"
) > %project_dir%\%project_name%\%project_name%\Dockerfile


REM Add to docker-compose.yml
(
echo version: "3"
echo.
echo services:
echo   workspace:
echo     container_name: "%project_name%"
echo     image: %project_name%
echo     build:
echo       context: .
echo       dockerfile: Dockerfile
echo     volumes:
echo       - ./storage:/src/storage
echo     networks:
echo       - custom
echo     command: tail -f /dev/null
echo.
echo networks:
echo   custom:
echo     driver: bridge
echo.
echo #volumes:
echo #  %project_name%_data:
) > %project_dir%\%project_name%\%project_name%\docker-compose.yml

REM Create Makefile
(
echo check:
echo 	python main.py
echo build:
echo 	docker build -t %project_name% .
echo up:
echo 	docker-compose up -d
echo down:
echo 	docker-compose down
echo app:
echo 	poetry run uvicorn src.main:app --reload --host 127.0.0.1 --port 8000
echo test:
echo 	poetry run coverage run -m pytest .
echo 	poetry run coverage html
echo 	poetry run black ./
echo 	poetry run ruff check --fix .
echo #	poetry run mypy ./
echo #	poetry run pylint ./src
echo migrations:
echo #	alembic init migrations
echo #	alembic init -t async migrations
echo 	alembic revision --autogenerate -m "make migrations"
echo 	alembic upgrade heads
) > %project_dir%\%project_name%\%project_name%\Makefile

cd %project_dir%\%project_name%\%project_name%
poetry install

set /p project_name="Succes. Enter to exit."

REM Deactivating a virtual environment
deactivate
exit
endlocal
