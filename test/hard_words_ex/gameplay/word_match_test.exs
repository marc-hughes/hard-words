defmodule HardWordsEx.Gameplay.WordMatchTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.WordMatch
  alias HardWordsEx.Gameplay.Feedback

  test "Word matches correct feedback" do
    feedback = [
      %Feedback{letter: "h", position: 0, state: :correct},
      %Feedback{letter: "a", position: 1, state: :correct},
      %Feedback{letter: "r", position: 2, state: :correct},
      %Feedback{letter: "p", position: 3, state: :correct},
      %Feedback{letter: "y", position: 4, state: :correct}
    ]

    assert wordMatches("harpy", feedback)
  end

  test "Words that shouldn't match the feedback" do
    feedback = [
      %Feedback{letter: "h", state: :correct, position: 0},
      %Feedback{letter: "a", state: :wrong_position, position: 1},
      %Feedback{letter: "r", state: :incorrect, position: 2},
      %Feedback{letter: "p", state: :incorrect, position: 3},
      %Feedback{letter: "y", state: :incorrect, position: 4}
    ]

    # Missing the h
    assert not wordMatches("bongs", feedback)
    # We know that A is in the wrong spot
    assert not wordMatches("hangs", feedback)
    # Missing an A
    assert not wordMatches("hongs", feedback)
    # Shouldn't have an R
    assert not wordMatches("hrags", feedback)
    # The first A shouldn't be there even though we have another a
    assert not wordMatches("hanas", feedback)
  end

  test "Words that should match the feedback" do
    feedback = [
      %Feedback{letter: "h", state: :correct, position: 0},
      %Feedback{letter: "a", state: :wrong_position, position: 1},
      %Feedback{letter: "r", state: :incorrect, position: 2},
      %Feedback{letter: "p", state: :incorrect, position: 3},
      %Feedback{letter: "y", state: :incorrect, position: 4}
    ]

    assert wordMatches("hoags", feedback)
    assert wordMatches("honas", feedback)
    assert wordMatches("hzaga", feedback)
  end

  test "Words that should match all wrong feedback" do
    feedback = [
      %Feedback{letter: "h", state: :incorrect, position: 0},
      %Feedback{letter: "a", state: :incorrect, position: 1},
      %Feedback{letter: "r", state: :incorrect, position: 2},
      %Feedback{letter: "p", state: :incorrect, position: 3},
      %Feedback{letter: "y", state: :incorrect, position: 4}
    ]

    assert wordMatches("bongs", feedback)
    assert wordMatches("timid", feedback)
  end

  test "filterWords" do
    # Here's some sample feedback representing 2 guesses
    # [h✔] [a wrong spot] [r❌] [p❌] [y❌]
    # [b❌] [o❌] [n✔] [g wrong spot] [s❌]
    # So we know that:
    #  H is the first letter
    #  N is the third letter
    #  There is an A, but not in the second spot
    #  There is a g, but not in the 4th spot
    feedback = [
      [
        %Feedback{letter: "h", state: :correct, position: 0},
        %Feedback{letter: "a", state: :wrong_position, position: 1},
        %Feedback{letter: "r", state: :incorrect, position: 2},
        %Feedback{letter: "p", state: :incorrect, position: 3},
        %Feedback{letter: "y", state: :incorrect, position: 4}
      ],
      [
        %Feedback{letter: "b", state: :incorrect, position: 0},
        %Feedback{letter: "o", state: :incorrect, position: 1},
        %Feedback{letter: "n", state: :correct, position: 2},
        %Feedback{letter: "g", state: :wrong_position, position: 3},
        %Feedback{letter: "s", state: :incorrect, position: 4}
      ]
    ]

    words = [
      "hgnaz",
      "hanzz",
      "ahnzz",
      "hznag"
    ]

    assert filterWords(words, feedback) == ["hgnaz", "hznag"]
  end

  test "Works against the full list" do
    feedback = [
      [
        %Feedback{letter: "h", state: :correct, position: 0},
        %Feedback{letter: "a", state: :wrong_position, position: 1},
        %Feedback{letter: "r", state: :incorrect, position: 2},
        %Feedback{letter: "p", state: :incorrect, position: 3},
        %Feedback{letter: "y", state: :incorrect, position: 4}
      ]
    ]

    assert filterWords(HardWordsEx.Gameplay.AllowedAnswers.words(), feedback) == [
             "heath",
             "heave",
             "human"
           ]

    feedback = [
      [
        %Feedback{letter: "h", state: :incorrect, position: 0},
        %Feedback{letter: "a", state: :wrong_position, position: 1},
        %Feedback{letter: "r", state: :incorrect, position: 2},
        %Feedback{letter: "p", state: :incorrect, position: 3},
        %Feedback{letter: "y", state: :incorrect, position: 4}
      ],
      [
        %Feedback{letter: "h", state: :incorrect, position: 0},
        %Feedback{letter: "e", state: :wrong_position, position: 1},
        %Feedback{letter: "r", state: :incorrect, position: 2},
        %Feedback{letter: "p", state: :incorrect, position: 3},
        %Feedback{letter: "y", state: :incorrect, position: 4}
      ]
    ]

    assert length(filterWords(HardWordsEx.Gameplay.AllowedAnswers.words(), feedback)) == 85
  end
end
