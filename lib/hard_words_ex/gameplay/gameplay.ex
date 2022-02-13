defmodule HardWordsEx.Gameplay.Gameplay do
  alias HardWordsEx.Gameplay.GameState

  def initialState() do
    %GameState{}
  end

  def initialState(forbiddenWords) do
    %GameState{forbiddenWords: forbiddenWords}
  end

  def makeGuess(
        %GameState{
          previousFeedback: previousFeedback,
          previousGuesses: previousGuesses,
          forbiddenWords: forbiddenWords
        },
        guess
      ) do
    guess = String.downcase(guess)

    allowedWords = HardWordsEx.Gameplay.AllowedAnswers.words() -- forbiddenWords

    # Take all words, an filter them down to match the feedback we've already given.
    availableWords =
      HardWordsEx.Gameplay.WordMatch.filterWords(
        allowedWords,
        previousFeedback
      )

    # Now, out of that list, find the "worst" group of matches compared to the new guess
    {_, possibleWords} = HardWordsEx.Gameplay.BadMatches.getBadMatches(availableWords, guess)

    # Pick one of them at random
    targetWord = to_string(Enum.random(possibleWords))

    # Based on that new target word, generate new feedback
    newFeedback = HardWordsEx.Gameplay.FeedbackGenerator.generateFeedback(guess, targetWord)

    %GameState{
      forbiddenWords: forbiddenWords,
      previousGuesses: [guess | previousGuesses],
      previousFeedback: [newFeedback | previousFeedback],
      gameOver: length(previousGuesses) === 5 or targetWord == guess,
      answer: targetWord,
      winner: guess == targetWord
    }
  end
end
