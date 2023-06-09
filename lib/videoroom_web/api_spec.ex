defmodule VideoroomWeb.ApiSpec do
  @moduledoc false
  @behaviour OpenApiSpex.OpenApi

  alias OpenApiSpex.{Info, Paths, Schema, Server}

  # OpenAPISpex master specification

  @impl OpenApiSpex.OpenApi
  def spec() do
    %OpenApiSpex.OpenApi{
      info: %Info{
        title: "Videoroom",
        version: "0.1.0"
      },
      servers: [
        Server.from_endpoint(VideoroomWeb.Endpoint)
      ],
      paths: Paths.from_router(VideoroomWeb.Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end

  @spec data(String.t(), Schema.t()) :: {String.t(), String.t(), Schema.t()}
  def data(description, schema) do
    {description, "application/json", schema}
  end

  @spec error(String.t()) :: {String.t(), String.t(), module()}
  def error(description) do
    {description, "application/json", VideoroomWeb.ApiSpec.Error}
  end
end
