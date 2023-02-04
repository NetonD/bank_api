defmodule BankAPI.Accounts.Events.AccountOpened do
  @derive [Jason.Encoder]
  defstruct ~w(account_uuid initial_balance)a
end
