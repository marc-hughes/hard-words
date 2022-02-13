defmodule HardWordsEx.Gameplay.GameState do
  defstruct previousGuesses: [], previousFeedback: [], gameOver: false, answer: "", winner: false
end
