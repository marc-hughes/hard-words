defmodule HardWordsEx.Gameplay.BadMatchesTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.BadMatches

  test "Get bad matches" do
    assert getBadMatches(["abc", "def", "ghi"], "axx") == {0, ["ghi", "def"]}

    list = [
      "aaaa",
      "aaab",
      "aaac",
      "aaad",
      "aabc"
    ]

    {score, words} = getBadMatches(list, "aaaa")
    assert score == 10
    assert words == ["aabc"]

    assert getBadMatches(list, "axxx") ==
             {3,
              [
                "aabc",
                "aaad",
                "aaac",
                "aaab",
                "aaaa"
              ]}
  end

  test "Guesses narrow down list" do
    {score, words} = getBadMatches(HardWordsEx.Gameplay.AllowedAnswers.words(), "bongs")
    assert score == 0
    assert length(words) == 644

    # Use the left-over words from before as valid choices for the next guess to narrow it down
    {score, words} = getBadMatches(words, "harpy")
    assert score == 0
    assert length(words) == 65

    {score, words} = getBadMatches(words, "tumid")
    assert score == 0
    assert length(words) == 4

    {score, words} = getBadMatches(words, "fleck")
    assert score == 4
    assert length(words) == 2
    assert words == ["jewel", "level"]

    {score, words} = getBadMatches(words, "jewel")
    assert score == 9
    assert length(words) == 1
    assert words == ["level"]

    {score, words} = getBadMatches(words, "level")
    assert score == 15
    assert length(words) == 1
    assert words == ["level"]
  end
end
