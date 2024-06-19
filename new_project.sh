#!/bin/bash

# Project name prompt
main_path=$(pwd)
project_dir="$HOME/Projects"
python_version=$(python3 --version 2>&1 | awk '{print $2}' | cut -d '.' -f 1,2)
read -p "Enter name your project: " project_name

# Creating a Project Directory
mkdir $project_dir/$project_name
cd $project_dir/$project_name

# Creating a virtual environment
python3 -m venv venv

# Activating the virtual environment
source venv/bin/activate

# Updating pip and installing poetry
python3 -m pip install --upgrade pip
pip install poetry

mkdir -p $project_dir/$project_name

# Creating the necessary files
touch $project_dir/$project_name/LICENSE
touch $project_dir/$project_name/pre-commit.yml
touch $project_dir/$project_name/.env.secret

mkdir -p $project_dir/$project_name/.github/workflows
mkdir -p $project_dir/$project_name/src
mkdir -p $project_dir/$project_name/tests
mkdir -p $project_dir/$project_name/tests/unit
mkdir -p $project_dir/$project_name/tests/e2e
mkdir -p $project_dir/$project_name/tests/integration
mkdir -p $project_dir/$project_name/logs
mkdir -p $project_dir/$project_name/docs

touch $project_dir/$project_name/.github/workflows/ci.yml
touch $project_dir/$project_name/src/__init__.py
touch $project_dir/$project_name/tests/conftest.py

# Copying files
cp $main_path/files/commands.md $project_dir/$project_name
cp $main_path/files/settings.py $project_dir/$project_name/src
cp $main_path/files/main.py $project_dir/$project_name/src
cp $main_path/files/.env.dev $project_dir/$project_name
cp $main_path/files/.gitignore $project_dir/$project_name
cp $main_path/files/.dockerignore $project_dir/$project_name
cp $main_path/files/README.md $project_dir/$project_name

# Create pyproject.toml
cat <<EOL > "$project_dir/$project_name/pyproject.toml"
[tool.poetry]
name = "$project_name"
version = "0.1.0"
description = ""
authors = ["Kirill Nerush <nerush.kirill@gmail.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^$python_version"

[tool.poetry.group.dev.dependencies]

[tool.mypy]
python_version = $python_version
plugins = ["sqlalchemy.ext.mypy.plugin"]
ignore_missing_imports = true

[[tool.mypy.overrides]]
module = "*.migrations.*"
ignore_errors = true

[tool.ruff]
# https://beta.ruff.rs/docs/configuration/
select = ["E", "W", "F", "I", "B", "C4", "ARG", "SIM"]
ignore = ["W291", "W292", "W293"]

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
EOL

# Add to Dockerfile
cat <<EOL > "$project_dir/$project_name/$project_name/Dockerfile"
# Default to the latest slim version of Python
ARG PYTHON_IMAGE_TAG=$python_version-alpine3.19

# POETRY BASE IMAGE - Provides environment variables for poetry
FROM python:\${PYTHON_IMAGE_TAG} AS python-base

# POETRY BUILDER IMAGE - Installs Poetry and dependencies
FROM python-base AS python-poetry-builder

RUN pip install --upgrade pip
RUN apk add gcc musl-dev libffi-dev
RUN pip install poetry

# POETRY RUNTIME IMAGE - Copies the poetry installation into a smaller image
FROM python-poetry-builder AS python-poetry
COPY --from=python-poetry-builder \$POETRY_HOME \$POETRY_HOME

# MY PROJECTS
FROM python-poetry AS $project_name

WORKDIR /$project_name
COPY . /$project_name

RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi --without dev
EOL

# Add to docker-compose.yml
cat <<EOL > "$project_dir/$project_name/docker-compose.yml"
version: "3"

services:
  workspace:
    container_name: "$project_name"
    image: $project_name
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./storage:/src/storage
    networks:
      - custom
    command: tail -f /dev/null

networks:
  custom:
    driver: bridge

#volumes:
#  ${project_name}_data:
EOL

# Create Makefile
cat <<EOL > "$project_dir/$project_name/$project_name/Makefile"
check:
	python main.py
build:
	docker build -t $project_name .
up:
	docker-compose up -d
down:
	docker-compose down
app:
	poetry run uvicorn src.main:app --reload --host 127.0.0.1 --port 8000
test:
	poetry run coverage run -m pytest .
	poetry run coverage html
	poetry run black ./
	poetry run ruff check --fix .
#	poetry run mypy ./
#	poetry run pylint ./src
migrations:
#	alembic init migrations
#	alembic init -t async migrations
	alembic revision --autogenerate -m "make migrations"
	alembic upgrade heads
EOL

cd $project_dir/$project_name

poetry install --no-root
poetry add pydantic-settings

read -p "Success. Press enter to exit."

# Deactivating a virtual environment
deactivate
exit 0
