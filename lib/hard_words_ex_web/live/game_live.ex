# 2 things we need to worry about,
#  1. The current game state from HardWordsEx.Gameplay
#  2. The currently partially-entered input from the user

defmodule HardWordsExWeb.GameLive do
  use HardWordsExWeb, :live_view
  import HardWordsEx.Gameplay.Gameplay
  alias HardWordsEx.Gameplay.AllowedWords
  alias HardWordsEx.Accounts
  alias HardWordsEx.Gameplay.ScoreLog

  def saveScore(word, winner, tries, user_token) do
    user = user_token && Accounts.get_user_by_session_token(user_token)
    ScoreLog.insertScore(word, winner, tries, user)
  end

  def doGuess(socket, game, word, user_token) do
    newState = makeGuess(game, word)

    if newState.gameOver do
      saveScore(game.answer, game.winner, length(game.previousGuesses) + 1, user_token)
    end

    {:noreply, assign(socket, %{:word => "", :game => newState})}
  end

  def handle_event("key_down", %{"key" => "Enter"}, socket) do
    %{word: word, game: game, user_token: user_token} = socket.assigns

    cond do
      not Enum.any?(AllowedWords.words(), fn w -> String.upcase(w) == word end) ->
        {:noreply, socket}

      Enum.any?(game.previousGuesses, fn w -> String.upcase(w) == word end) ->
        {:noreply, socket}

      game.gameOver ->
        {:noreply, socket}

      String.length(word) === 5 ->
        doGuess(socket, game, word, user_token)

      true ->
        {:noreply, socket}
    end
  end

  def handle_event("key_down", %{"key" => "Backspace"}, socket) do
    %{word: word} = socket.assigns
    {newWord, _} = String.split_at(word, -1)
    {:noreply, assign(socket, %{:word => newWord})}
  end

  def handle_event("key_down", %{"key" => key}, socket) do
    cond do
      String.length(key) > 1 -> {:noreply, socket}
      String.length(socket.assigns.word) >= 5 -> {:noreply, socket}
      true -> {:noreply, assign(socket, %{:word => socket.assigns.word <> String.upcase(key)})}
    end
  end

  def handle_event("play_again", _val, socket) do
    {:noreply,
     assign(socket, %{
       :word => "",
       :game => initialState()
     })}
  end

  def alphabet(feedback) do
    HardWordsEx.Gameplay.Letters.alphabetStatus(feedback)
  end

  def placeholders(guesses) do
    cond do
      length(guesses) >= 5 -> []
      true -> Enum.to_list(1..(5 - length(guesses)))
    end
  end

  def mount(params, session, socket) do
    IO.puts("Session:")
    IO.inspect(session)
    IO.inspect(params)

    {:ok,
     assign(socket, %{
       :user_token => session["user_token"],
       :word => "",
       :game => initialState()
     })}
  end
end
