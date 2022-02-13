# 2 things we need to worry about,
#  1. The current game state from HardWordsEx.Gameplay
#  2. The currently partially-entered input from the user

defmodule HardWordsExWeb.GameLive do
  use HardWordsExWeb, :live_view
  import HardWordsEx.Gameplay.Gameplay
  alias HardWordsEx.Gameplay.AllowedWords
  alias HardWordsEx.Accounts
  alias HardWordsEx.Gameplay.ScoreLog
  import Ecto.Query, only: [from: 2]
  alias HardWordsEx.Repo

  def saveScore(word, winner, tries, user_token) do
    user = user_token && Accounts.get_user_by_session_token(user_token)
    ScoreLog.insertScore(word, winner, tries, user)
  end

  def handleSubmit(socket) do
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

  def doGuess(socket, game, word, user_token) do
    newState = makeGuess(game, word)

    if newState.gameOver do
      saveScore(
        newState.answer,
        newState.winner,
        length(newState.previousGuesses),
        user_token
      )
    end

    {:noreply, assign(socket, %{:word => "", :game => newState})}
  end

  def addLetter(letter, socket) do
    cond do
      String.length(letter) > 1 -> {:noreply, socket}
      String.length(socket.assigns.word) >= 5 -> {:noreply, socket}
      true -> {:noreply, assign(socket, %{:word => socket.assigns.word <> String.upcase(letter)})}
    end
  end

  def delLetter(socket) do
    %{word: word} = socket.assigns
    {newWord, _} = String.split_at(word, -1)
    {:noreply, assign(socket, %{:word => newWord})}
  end

  def handle_event("pick_letter", %{"letter" => "ENTER"}, socket) do
    handleSubmit(socket)
  end

  def handle_event("pick_letter", %{"letter" => "BACKSPACE"}, socket) do
    delLetter(socket)
  end

  def handle_event("pick_letter", %{"letter" => letter}, socket) do
    addLetter(letter, socket)
  end

  def handle_event("key_down", %{"key" => "Enter"}, socket) do
    handleSubmit(socket)
  end

  def handle_event("key_down", %{"key" => "Backspace"}, socket) do
    delLetter(socket)
  end

  def handle_event("key_down", %{"key" => key}, socket) do
    addLetter(key, socket)
  end

  def handle_event("play_again", _val, socket) do
    user_token = socket.assigns["user_token"]
    user = Accounts.get_user_by_session_token(user_token)

    {:noreply,
     assign(socket, %{
       :word => "",
       :game => newGame(user)
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

  def newGame(user) do
    previousScores =
      Repo.all(
        from(s in HardWordsEx.Gameplay.ScoreLog,
          where: s.user_id == ^user.id
        )
      )

    previousWords = for score <- previousScores, do: score.word
    IO.inspect(previousWords)

    initialState(previousWords)
  end

  def mount(_params, session, socket) do
    user_token = session["user_token"]
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
     assign(socket, %{
       :user_token => user_token,
       :word => "",
       :game => newGame(user)
     })}
  end
end
