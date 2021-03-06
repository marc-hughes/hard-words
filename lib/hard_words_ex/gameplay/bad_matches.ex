defmodule HardWordsEx.Gameplay.BadMatches do
  # Look through a list of words and give us a set of candidates that are "bad" matches
  # for a given guess where "bad" is defined as the lowest score via this criteria:
  #
  # Letter not found: 0
  # Letter found, wrong place: 2
  # Letter found, correct place: 3
  #
  # Returns {score, wordList}
  def getBadMatches(words, guess) do
    Enum.reduce(words, {9999, []}, fn target, {lowScore, wordList} ->
      {:ok, score} = HardWordsEx.Gameplay.WordScore.wordScore(target, guess)

      cond do
        score < lowScore -> {score, [target]}
        score == lowScore -> {score, [target | wordList]}
        true -> {lowScore, wordList}
      end
    end)
  end
end
