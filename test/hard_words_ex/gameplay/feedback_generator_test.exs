defmodule HardWordsEx.Gameplay.FeedbackGeneratorTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.FeedbackGenerator
  alias HardWordsEx.Gameplay.Feedback

  test "Generates valid feedback with no match" do
    assert generateFeedback("aaaaa", "bbbbb") == [
             %Feedback{letter: "a", position: 0, state: :incorrect},
             %Feedback{letter: "a", position: 1, state: :incorrect},
             %Feedback{letter: "a", position: 2, state: :incorrect},
             %Feedback{letter: "a", position: 3, state: :incorrect},
             %Feedback{letter: "a", position: 4, state: :incorrect}
           ]
  end

  test "Generates valid feedback on exact" do
    assert generateFeedback("harpy", "harpy") == [
             %Feedback{letter: "h", position: 0, state: :correct},
             %Feedback{letter: "a", position: 1, state: :correct},
             %Feedback{letter: "r", position: 2, state: :correct},
             %Feedback{letter: "p", position: 3, state: :correct},
             %Feedback{letter: "y", position: 4, state: :correct}
           ]
  end

  test "Generates valid feedback on wrong position" do
    assert generateFeedback("yprah", "harpy") == [
             %Feedback{letter: "y", position: 0, state: :wrong_position},
             %Feedback{letter: "p", position: 1, state: :wrong_position},
             %Feedback{letter: "r", position: 2, state: :correct},
             %Feedback{letter: "a", position: 3, state: :wrong_position},
             %Feedback{letter: "h", position: 4, state: :wrong_position}
           ]
  end
end
