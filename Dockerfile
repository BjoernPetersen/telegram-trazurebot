FROM ghcr.io/blindfoldedsurgery/poetry:2.1.2-pipx-3.13-bookworm

USER root

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
      ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives \

USER app

COPY [ "poetry.toml", "poetry.lock", "pyproject.toml", "./" ]

RUN poetry install --no-interaction --ansi --only=main --no-root

# We don't want the tests
COPY src/bot ./src/bot

RUN poetry install --no-interaction --ansi --only-root

ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION

CMD [ "python", "-m", "bot.app", "handle-updates" ]
