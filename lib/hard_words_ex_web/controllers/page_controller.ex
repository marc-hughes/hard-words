defmodule HardWordsExWeb.PageController do
  use HardWordsExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
