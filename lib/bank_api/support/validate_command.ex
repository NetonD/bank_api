# lib/bank_api/support/middleware/validate_command.ex

defmodule BankAPI.Middleware.ValidateCommand do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case command.__struct__.valid?(command) do
      {:ok, _command} ->
        pipeline

      {:error, _changeset} = error_tuple ->
        pipeline
        |> Pipeline.respond(error_tuple)
        |> Pipeline.halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end
