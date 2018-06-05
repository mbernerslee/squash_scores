defmodule SquashScores.Rankings.MatchTest do
  use ExUnit.Case
  alias SquashScores.Rankings.Match

  describe "record/5" do
    test "with current scores, players, match result and k_value, updaes the scores" do
      pre_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jim", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jenny", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      post_match_scores =
        [
          %{player: "Dave", wins: 1, losses: 0, draws: 0, games_played: 1, elo: 1516},
          %{player: "Mary", wins: 0, losses: 1, draws: 0, games_played: 1, elo: 1484},
          %{player: "Jim", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jenny", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      assert {:ok, post_match_scores} == Match.record(pre_match_scores, "Dave", "Mary", "Dave")
    end

    test "returns error when player does not exist" do
      assert {:error, "Recording match failed. Player 'Dave' not found"} == Match.record([], "Dave", "Mary", "Dave")
    end
  end

end
