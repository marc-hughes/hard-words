defmodule HardWordsExWeb.GameLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use HardWordsExWeb, :live_view

  def mount(_params, params, socket) do
    {:ok, assign(socket, %{:test => "hello"})}
  end
end
