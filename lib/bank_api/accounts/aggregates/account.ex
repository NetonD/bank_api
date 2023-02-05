defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct ~w(uuid current_balance)a

  alias __MODULE__
  alias BankAPI.Accounts.Commands.OpenAccount
  alias BankAPI.Accounts.Events.AccountOpened

  def execute(%Account{uuid: nil}, %OpenAccount{
        account_uuid: account_uuid,
        initial_balance: initial_balance
      })
      when initial_balance > 0 do
    %AccountOpened{initial_balance: initial_balance, account_uuid: account_uuid}
  end

  def execute(%Account{uuid: nil}, %OpenAccount{initial_balance: initial_balance})
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_greater_than_zero}
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  def apply(%Account{} = account, %AccountOpened{
        account_uuid: account_uuid,
        initial_balance: initial_balance
      }) do
    %Account{account | uuid: account_uuid, current_balance: initial_balance}
  end
end
