defmodule HardWordsEx.Gameplay.GameplayTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.Gameplay
  alias HardWordsEx.Gameplay.GameState
  alias HardWordsEx.Gameplay.Feedback

  test "Make Guess returns valid output" do
    state = initialState()

    %GameState{
      previousFeedback: previousFeedback,
      previousGuesses: previousGuesses
    } = makeGuess(state, "harpy")

    assert previousGuesses == ["harpy"]

    assert previousFeedback == [
             [
               %Feedback{letter: "h", state: :incorrect, position: 0},
               %Feedback{letter: "a", state: :incorrect, position: 1},
               %Feedback{letter: "r", state: :incorrect, position: 2},
               %Feedback{letter: "p", state: :incorrect, position: 3},
               %Feedback{letter: "y", state: :incorrect, position: 4}
             ]
           ]
  end
end
