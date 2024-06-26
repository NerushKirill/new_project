from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=("../.env.dev", "../.env.secret"),
        env_file_encoding="utf-8",
    )

    test_env: str


settings = Settings()
