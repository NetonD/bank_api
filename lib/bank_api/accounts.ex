defmodule BankAPI.Accounts do
  @moduledoc """
  Surface of interface to Account context.
  """

  alias Ecto.Changeset
  alias BankAPI.Accounts.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  alias BankAPI.Accounts.Projections.Account

  alias BankAPI.Repo

  import Ecto.Changeset

  def get_account!(account_uuid), do: Repo.get!(Account, account_uuid)

  def open_account(%{"initial_balance" => initial_balance}) do
    account_uuid = Ecto.UUID.generate()

    case dispatch_command(%OpenAccount{
           initial_balance: initial_balance,
           account_uuid: account_uuid
          }) do
      :ok -> {:ok, %Account{uuid: account_uuid, current_balance: initial_balance}}
      reply -> reply
    end
  end

  def open_account(_), do: {:error, :bad_command}

  defp dispatch_command(command) do
    BankAPI.CommandedApplication.dispatch(command)
  end
end
