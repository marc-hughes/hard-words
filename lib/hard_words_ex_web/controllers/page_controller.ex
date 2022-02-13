defmodule HardWordsExWeb.PageController do
  use HardWordsExWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias HardWordsEx.Repo

  def render_index(conn, nil) do
    conn
    |> render("index.html")
  end

  def render_index(conn, user) do
    scores =
      cond do
        user ->
          Repo.all(
            from(s in HardWordsEx.Gameplay.ScoreLog,
              where: s.user_id == ^user.id,
              order_by: [desc: s.inserted_at]
            )
          )

        true ->
          []
      end

    conn
    |> assign(:scores, scores)
    |> render("index-user.html")
  end

  def index(conn, _params) do
    user = conn.assigns.current_user
    render_index(conn, user)
  end
end
