defmodule BankApi.Accounts do
  @moduledoc """
  Surface of interface to Account context.
  """

  alias Ecto.Changeset
  alias BankAPI.Accounts.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  alias BankAPI.Accounts.Projections.Account

  alias BankAPI.Repo
  alias BankAPI.Router

  import Ecto.Changeset

  def get_account!(account_uuid), do: Repo.get!(Account, account_uuid)

  def open_account(account_params) do
    account_uuid = Ecto.UUID.generate()

    with %{valid?: true} = changeset <- account_opening_changeset(account_params),
         :ok <-
           Router.dispatch(%OpenAccount{
             initial_balance: changeset.changes.initial_balance,
             account_uuid: account_uuid
           }) do
      {:ok, %Account{uuid: account_uuid, current_balance: changeset.changes.initial_balance}}
    else
      %{valid?: false} = changeset -> {:validation_error, changeset}
      reply -> reply
    end
  end

  @spec account_opening_changeset(map()) :: Changeset.t()
  defp account_opening_changeset(account_params) do
    {account_params, %{initial_balance: :integer}}
    |> cast(account_params, [:initial_balance])
    |> validate_required([:initial_balance])
    |> validate_number(:initial_balance, greater_than: 0)
  end
end
