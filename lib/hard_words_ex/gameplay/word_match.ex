# {:feedback,
#  letter,   The letter we guessed
#  :correct | :incorrect | :wrong_position,  The state of that guess
#  position           Where it was, 0 based index into the word
# }

# This is the logic to figure out which words we could shift to, while still keeping all feedback given
# to the user valid.
# So if we told them:
#  [H✔] [A Wrong Spot] [R❌] [P❌] [Y❌]
# Then we need to find words that fit that feedback:
#   Every correct feedback should match exactly
#   Every wrong spot feedback, should have the letter in a different spot
#   Every incorrect feedback, must not appear

defmodule HardWordsEx.Gameplay.WordMatch do
  alias HardWordsEx.Gameplay.Feedback

  defp checkFeedback(characters, %Feedback{
         letter: letter,
         position: position,
         state: :correct
       }) do
    # Correct case, has to be in the exact position
    Enum.at(characters, position) == letter
  end

  defp checkFeedback(characters, %Feedback{
         letter: letter,
         state: :incorrect
       }) do
    # Incorrect case, letter can't exist at all
    not Enum.any?(characters, fn c -> c == letter end)
  end

  defp checkFeedback(characters, %Feedback{
         letter: letter,
         position: position,
         state: :wrong_position
       }) do
    # For wrong position, it has to exist, but it can't be in the place we know is the wrong spot
    Enum.any?(characters, fn c -> c == letter end) and Enum.at(characters, position) != letter
  end

  def wordMatches(word, feedbackList) do
    characters = String.split(word, "", trim: true)
    Enum.all?(feedbackList, &checkFeedback(characters, &1))
  end

  def filterWords(words, previousFeedback) do
    Enum.filter(words, fn word ->
      Enum.all?(previousFeedback, fn feedback -> wordMatches(word, feedback) end)
    end)
  end
end
