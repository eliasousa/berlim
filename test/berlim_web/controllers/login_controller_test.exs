defmodule BerlimWeb.LoginControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  describe "GET /new, when user is not authenticated" do
    test "shows login page", %{conn: conn} do
      conn = get(conn, Routes.login_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "POST /create, when user is not authenticated" do
    setup do
      %{
        admin: insert_user_with_this_password(:admin, "1234"),
        taxi: insert_user_with_this_password(:taxi, "1234")
      }
    end

    test "admin with valid credentials, sign in admin and redirects to Admin /index", %{
      conn: conn,
      admin: admin
    } do
      conn =
        post(conn, Routes.login_path(conn, :create),
          auth_params: build_params(admin.email, "1234")
        )

      assert get_session(conn, :user_id) == admin.id
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
      assert get_flash(conn, :info) == "Login efetuado com sucesso"
    end

    test "admin with invalid email, shows 'wrong email or password' error message", %{conn: conn} do
      conn =
        post(conn, Routes.login_path(conn, :create),
          auth_params: build_params("email@com", "1234")
        )

      assert get_flash(conn, :error) == "Email ou senha incorretos"
      assert html_response(conn, 200) =~ "Login"
    end

    test "admin with invalid password, shows 'wrong email or password' error message", %{
      conn: conn,
      admin: admin
    } do
      conn =
        post(conn, Routes.login_path(conn, :create),
          auth_params: build_params(admin.email, "invalidpass")
        )

      assert get_flash(conn, :error) == "Email ou senha incorretos"
      assert html_response(conn, 200) =~ "Login"
    end

    test "taxi with valid credentials, sign in taxi and redirects to Dashboard /index", %{
      conn: conn,
      taxi: taxi
    } do
      conn =
        post(conn, Routes.login_path(conn, :create), auth_params: build_params(taxi.email, "1234"))

      assert get_session(conn, :user_id) == taxi.id
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :info) == "Login efetuado com sucesso"
    end

    test "taxi with invalid email, shows 'wrong email or password' error message", %{conn: conn} do
      conn =
        post(conn, Routes.login_path(conn, :create),
          auth_params: build_params("email@com", "1234")
        )

      assert get_flash(conn, :error) == "Email ou senha incorretos"
      assert html_response(conn, 200) =~ "Login"
    end

    test "taxi with invalid password, shows 'wrong email or password' error message", %{
      conn: conn,
      taxi: taxi
    } do
      conn =
        post(conn, Routes.login_path(conn, :create),
          auth_params: build_params(taxi.email, "invalidpass")
        )

      assert get_flash(conn, :error) == "Email ou senha incorretos"
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "DELETE /sign-out, when user is authenticated" do
    setup %{conn: conn} do
      %{conn: authenticate(conn)}
    end

    test "signs out user", %{conn: conn} do
      conn = delete(conn, Routes.login_path(conn, :delete))

      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert get_flash(conn, :info) == "Logout efetuado com sucesso"
      assert is_nil(get_session(conn, :user_id))
    end
  end

  defp build_params(email, password) do
    %{email: email, password: password}
  end
end
