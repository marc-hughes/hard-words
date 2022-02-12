defmodule HardWordsEx.Gameplay.FeedbackGenerator do
  alias HardWordsEx.Gameplay.Feedback

  defp feedbackForChar({char, index}, targetChars) do
    cond do
      char == Enum.at(targetChars, index) ->
        %Feedback{letter: char, state: :correct, position: index}

      Enum.any?(targetChars, fn tc -> tc == char end) ->
        %Feedback{letter: char, state: :wrong_position, position: index}

      true ->
        %Feedback{letter: char, state: :incorrect, position: index}
    end
  end

  def generateFeedback(guess, target) do
    targetChars = String.split(target, "", trim: true)
    guessChars = String.split(guess, "", trim: true) |> Enum.with_index()

    Enum.map(guessChars, &feedbackForChar(&1, targetChars))
  end
end
