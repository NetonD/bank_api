defmodule BankAPI.Accounts.Commands.OpenAccount do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :initial_balance, :integer
  end

  def valid?(command) do
    %__MODULE__{}
    |> cast(Map.from_struct(command), [:initial_balance, :account_uuid])
    |> validate_required([:initial_balance, :account_uuid])
    |> validate_number(:initial_balance, greater_than: 0)
    |> apply_action(:validate)
  end
end
