defmodule BankAPI.Accounts.Commands.OpenAccount do
  @enforce_keys [:account_uuid]

  defstruct ~w(account_uuid initial_balance)a
end
