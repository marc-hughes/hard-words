defmodule HardWordsEx.Gameplay.LetterTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.Letters
  alias HardWordsEx.Gameplay.Feedback

  test "Should not be no status" do
    f = []
    assert letterStatus("A", f) == {"A", :none}
  end

  test "Should be correct" do
    f = [
      %Feedback{letter: "A", state: :correct}
    ]

    assert letterStatus("A", f) == {"A", :correct}
  end

  test "Should be found" do
    f = [
      %Feedback{letter: "A", state: :wrong_position}
    ]

    assert letterStatus("A", f) == {"A", :found}
  end

  test "Should not found" do
    f = [
      %Feedback{letter: "A", state: :incorrect}
    ]

    assert letterStatus("A", f) == {"A", :incorrect}
  end

  test "Should upgrade to correct" do
    f = [
      %Feedback{letter: "A", state: :wrong_position},
      %Feedback{letter: "A", state: :correct}
    ]

    assert letterStatus("A", f) == {"A", :correct}
  end

  test "alphabetStatus" do
    f = [
      [%Feedback{letter: "A", state: :wrong_position}],
      [%Feedback{letter: "B", state: :wrong_position}],
      [
        %Feedback{letter: "B", state: :wrong_position},
        %Feedback{letter: "C", state: :wrong_position},
        %Feedback{letter: "E", state: :incorrect}
      ]
    ]

    a = alphabetStatus(f)
    assert Enum.at(a, 0) == {"A", :found}
    assert Enum.at(a, 1) == {"B", :found}
    assert Enum.at(a, 2) == {"C", :found}
    assert Enum.at(a, 3) == {"D", :none}
    assert Enum.at(a, 4) == {"E", :incorrect}
  end

  @tag :wip
  test "alphabetstatus2" do
    f = [
      [
        %HardWordsEx.Gameplay.Feedback{
          letter: "y",
          position: 0,
          state: :wrong_position
        },
        %HardWordsEx.Gameplay.Feedback{
          letter: "y",
          position: 1,
          state: :wrong_position
        },
        %HardWordsEx.Gameplay.Feedback{letter: "y", position: 2, state: :correct},
        %HardWordsEx.Gameplay.Feedback{
          letter: "y",
          position: 3,
          state: :wrong_position
        },
        %HardWordsEx.Gameplay.Feedback{
          letter: "y",
          position: 4,
          state: :wrong_position
        }
      ],
      [
        %HardWordsEx.Gameplay.Feedback{letter: "a", position: 0, state: :incorrect},
        %HardWordsEx.Gameplay.Feedback{letter: "e", position: 1, state: :incorrect},
        %HardWordsEx.Gameplay.Feedback{letter: "i", position: 2, state: :incorrect},
        %HardWordsEx.Gameplay.Feedback{letter: "o", position: 3, state: :incorrect},
        %HardWordsEx.Gameplay.Feedback{letter: "u", position: 4, state: :incorrect}
      ]
    ]

    a = alphabetStatus(f)
    assert Enum.at(a, 24) == {"Y", :correct}
  end
end
