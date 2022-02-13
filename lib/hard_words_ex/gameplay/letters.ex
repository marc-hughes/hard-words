defmodule HardWordsEx.Gameplay.Letters do
  defp highestFeedback(:correct, _) do
    # short-circuit once we find it's correct
    :correct
  end

  defp highestFeedback(previousHigh, []) do
    # Ran out of items
    previousHigh
  end

  defp highestFeedback(previousHigh, [next | rest]) do
    # :correct | :incorrect | :wrong_position
    high =
      cond do
        next == :correct -> :correct
        next == :wrong_position -> :found
        previousHigh == :found -> :found
        next == :incorrect -> :incorrect
        true -> :not_found
      end

    highestFeedback(high, rest)
  end

  defp highestFeedback(feedback) do
    highestFeedback(:none, feedback)
  end

  def letterStatus(c, feedback) do
    letterFeedback = for f <- feedback, String.upcase(f.letter) == c, do: f.state

    {c, highestFeedback(letterFeedback)}
  end

  def alphabetStatus(feedback) do
    allFeedback = List.flatten(feedback)
    for c <- 65..90, do: letterStatus(to_string([c]), allFeedback)
  end
end
