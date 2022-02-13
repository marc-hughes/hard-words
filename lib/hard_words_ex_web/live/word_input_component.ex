defmodule HardWordsEx.WordInputComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    chars =
      assigns.word
      |> String.upcase()
      |> String.split("", trim: true)

    fullChars = chars ++ List.duplicate("", 5 - String.length(assigns.word))

    ~H"""
    <div class="word">
      <%= for c <- fullChars do %>
        <div class="character">
        <%= c %>
        </div>
      <% end %>
    </div>
    """
  end
end
