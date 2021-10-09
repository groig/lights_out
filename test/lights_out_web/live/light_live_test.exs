defmodule LightsOutWeb.LightLiveTest do
  use LightsOutWeb.ConnCase

  import Phoenix.LiveViewTest
  import LightsOut.LightsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_light(_) do
    light = light_fixture()
    %{light: light}
  end

  describe "Index" do
    setup [:create_light]

    test "lists all lights", %{conn: conn, light: light} do
      {:ok, _index_live, html} = live(conn, Routes.light_index_path(conn, :index))

      assert html =~ "Listing Lights"
      assert html =~ light.name
    end

    test "saves new light", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.light_index_path(conn, :index))

      assert index_live |> element("a", "New Light") |> render_click() =~
               "New Light"

      assert_patch(index_live, Routes.light_index_path(conn, :new))

      assert index_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#light-form", light: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.light_index_path(conn, :index))

      assert html =~ "Light created successfully"
      assert html =~ "some name"
    end

    test "updates light in listing", %{conn: conn, light: light} do
      {:ok, index_live, _html} = live(conn, Routes.light_index_path(conn, :index))

      assert index_live |> element("#light-#{light.id} a", "Edit") |> render_click() =~
               "Edit Light"

      assert_patch(index_live, Routes.light_index_path(conn, :edit, light))

      assert index_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#light-form", light: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.light_index_path(conn, :index))

      assert html =~ "Light updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes light in listing", %{conn: conn, light: light} do
      {:ok, index_live, _html} = live(conn, Routes.light_index_path(conn, :index))

      assert index_live |> element("#light-#{light.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#light-#{light.id}")
    end
  end

  describe "Show" do
    setup [:create_light]

    test "displays light", %{conn: conn, light: light} do
      {:ok, _show_live, html} = live(conn, Routes.light_show_path(conn, :show, light))

      assert html =~ "Show Light"
      assert html =~ light.name
    end

    test "updates light within modal", %{conn: conn, light: light} do
      {:ok, show_live, _html} = live(conn, Routes.light_show_path(conn, :show, light))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Light"

      assert_patch(show_live, Routes.light_show_path(conn, :edit, light))

      assert show_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#light-form", light: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.light_show_path(conn, :show, light))

      assert html =~ "Light updated successfully"
      assert html =~ "some updated name"
    end
  end
end
