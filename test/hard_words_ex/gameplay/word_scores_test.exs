defmodule HardWordsEx.Gameplay.WordScoresTest do
  use ExUnit.Case
  import HardWordsEx.Gameplay.WordScore

  test "Word score errors" do
    assert wordScore("abc", "ab") == {:error, "Strings are inconsistent length"}
    assert wordScore("abc", "abc") != {:error, "Strings are inconsistent length"}
  end

  test "Word score calculations" do
    # Correct 5-letter word
    assert wordScore("abcde", "abcde") == {:ok, 15}

    # Correct position:
    assert wordScore("abcd", "abcd") == {:ok, 12}
    assert wordScore("abcd", "abcx") == {:ok, 9}
    assert wordScore("abcd", "abxx") == {:ok, 6}
    assert wordScore("abcd", "axxx") == {:ok, 3}

    # Incorrect position:
    assert wordScore("abcd", "xxxa") == {:ok, 2}
    assert wordScore("abcd", "xxba") == {:ok, 4}
    assert wordScore("abcd", "xcba") == {:ok, 6}
    assert wordScore("abcd", "dcba") == {:ok, 8}

    # Mixed:
    assert wordScore("abcd", "axbx") == {:ok, 5}

    # None:
    assert wordScore("abcd", "xxxx") == {:ok, 0}

    # Duplicate
    assert wordScore("aabc", "aaxx") == {:ok, 6}
    assert wordScore("aabc", "axax") == {:ok, 5}
    assert wordScore("aabc", "xxaa") == {:ok, 4}
    # This one is weird... are both those A's incorrect placement, or only on
    assert wordScore("abcd", "xxaa") == {:ok, 4}
  end
end
