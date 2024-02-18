# Default to the latest slim version of Python
ARG PYTHON_IMAGE_TAG=3.11.8-alpine3.19

# POETRY BASE IMAGE - Provides environment variables for poetry
FROM python:${PYTHON_IMAGE_TAG} AS python-base

# POETRY BUILDER IMAGE - Installs Poetry and dependencies
FROM python-base AS python-poetry-builder

RUN pip install --upgrade pip
RUN apk add gcc musl-dev libffi-dev
RUN pip install poetry

# POETRY RUNTIME IMAGE - Copies the poetry installation into a smaller image
FROM python-poetry-builder AS python-poetry
COPY --from=python-poetry-builder $POETRY_HOME $POETRY_HOME

# MY PROJECTS
FROM python-poetry AS fastapi_lessons

WORKDIR /fastapi_lessons
COPY . /fastapi_lessons

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --without dev
