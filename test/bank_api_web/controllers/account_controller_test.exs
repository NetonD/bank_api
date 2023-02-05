defmodule BankAPIWeb.AccountControllerTest do
  use BankAPIWeb.ConnCase

  @create_attrs %{
    initial_balance: 42_00
  }

  @invalid_attrs %{
    initial_balance: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "render account when have valid attrs", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create, account: @create_attrs))

      assert %{"uuid" => _uuid, "account_balance" => 42_00} = json_response(201, conn)["data"]
    end

    test "render error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create, account: @invalid_attrs))

      assert json_response(201, conn)["errors"] != %{}
    end
  end
end
