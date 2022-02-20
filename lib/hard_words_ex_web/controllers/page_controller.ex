defmodule HardWordsExWeb.PageController do
  use HardWordsExWeb, :controller

  def render_index(conn, nil) do
    conn
    |> render("index.html")
  end

  def render_index(conn, user) do
    scores = HardWordsEx.Gameplay.ScoreLog.recentWords(user.id)

    conn
    |> assign(:scores, scores)
    |> render("index-user.html")
  end

  def index(conn, _params) do
    user = conn.assigns.current_user
    render_index(conn, user)
  end
end
