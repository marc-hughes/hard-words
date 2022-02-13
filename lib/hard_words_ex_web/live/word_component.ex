defmodule HardWordsEx.WordComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    %{feedback: feedback} = assigns

    ~H"""
    <div class="word">
      <%= for c <- feedback do %>
        <div class={"character " <> Atom.to_string(c.state)} >
        <%= String.upcase(c.letter) %>
        </div>
      <% end %>
    </div>
    """
  end
end
