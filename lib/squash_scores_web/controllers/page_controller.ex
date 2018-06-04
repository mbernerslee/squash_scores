defmodule SquashScoresWeb.PageController do
  use SquashScoresWeb, :controller
  alias SquashScores.Rankings

  def index(conn, _params) do
    rankings = Rankings.get!()
    render(conn, "index.html", rankings: rankings)
  end
end
