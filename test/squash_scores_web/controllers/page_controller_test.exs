defmodule SquashScoresWeb.PageControllerTest do
  use SquashScoresWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Squash ELO Rankings"
    assert %{rankings: _} = conn.assigns
  end
end
