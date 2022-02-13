defmodule HardWordsEx.Gameplay.Gameplay do
  alias HardWordsEx.Gameplay.GameState

  def initialState() do
    %GameState{}
  end

  def makeGuess(
        %GameState{
          previousFeedback: previousFeedback,
          previousGuesses: previousGuesses
        },
        guess
      ) do
    guess = String.downcase(guess)

    # Take all words, an filter them down to match the feedback we've already given.
    availableWords =
      HardWordsEx.Gameplay.WordMatch.filterWords(
        HardWordsEx.Gameplay.AllowedAnswers.words(),
        previousFeedback
      )

    # Now, out of that list, find the "worst" group of matches compared to the new guess
    {_, possibleWords} = HardWordsEx.Gameplay.BadMatches.getBadMatches(availableWords, guess)

    # Pick one of them at random
    targetWord = Enum.random(possibleWords)

    # Based on that new target word, generate new feedback
    newFeedback = HardWordsEx.Gameplay.FeedbackGenerator.generateFeedback(guess, targetWord)

    %GameState{
      previousGuesses: [guess | previousGuesses],
      previousFeedback: [newFeedback | previousFeedback],
      gameOver: length(previousGuesses) === 5 or targetWord == guess,
      answer: targetWord,
      winner: targetWord == guess
    }
  end
end
