defmodule HardWordsEx.Gameplay.GameState do
  defstruct previousGuesses: [], previousFeedback: []
  #   previousGuesses - List of strings corresponding to previous guesses
  #   previousFeedback - List of lists of previous feedback objects, one entry for each previous guess
end
