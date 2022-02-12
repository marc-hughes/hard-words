defmodule HardWordsEx.Gameplay.WordScore do
  defp wordScoreChars(targetChars, guessChars) when length(targetChars) != length(guessChars) do
    {:error, "Strings are inconsistent length"}
  end

  defp wordScoreChars(targetChars, guessChars) do
    score =
      guessChars
      |> Enum.zip(targetChars)
      |> Enum.with_index()
      |> Enum.reduce(0, fn {{guessChar, targetChar}, index}, acc ->
        cond do
          guessChar == targetChar -> acc + 3
          Enum.member?(targetChars, guessChar) -> acc + 2
          true -> acc
        end
      end)

    {:ok, score}
  end

  def wordScore(target, guess) do
    targetChars = String.split(target, "", trim: true)
    guessChars = String.split(guess, "", trim: true)
    wordScoreChars(targetChars, guessChars)
  end
end
