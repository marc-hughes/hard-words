defmodule HardWordsEx.Gameplay.Feedback do
  # State is :correct | :incorrect | :wrong_position
  defstruct letter: "", state: :incorrect, position: 0
end
