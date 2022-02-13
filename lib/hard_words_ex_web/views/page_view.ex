defmodule HardWordsExWeb.PageView do
  use HardWordsExWeb, :view

  def get_top_ten() do
    for u <- HardWordsEx.Accounts.get_top_ten(), do: {u.nickname, u.score}
  end

  def get_recent_words() do
    HardWordsEx.Gameplay.ScoreLog.recentScores()
  end
end
