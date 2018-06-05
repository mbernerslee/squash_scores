defmodule SquashScores.Rankings.MatchTest do
  use ExUnit.Case
  alias SquashScores.Rankings.Match

  describe "record/5" do
    test "with a winner" do
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

      pre_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jim", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jenny", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      post_match_scores =
        [
          %{player: "Jim", wins: 1, losses: 0, draws: 0, games_played: 1, elo: 1516},
          %{player: "Dave", wins: 0, losses: 1, draws: 0, games_played: 1, elo: 1484},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Jenny", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      assert {:ok, post_match_scores} == Match.record(pre_match_scores, "Jim", "Dave", "Jim")
    end

    test "with a winner, with different starting elos" do
      pre_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1000},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1950},
        ]

      post_match_scores =
        [
          %{player: "Dave", wins: 1, losses: 0, draws: 0, games_played: 1, elo: 1032},
          %{player: "Mary", wins: 0, losses: 1, draws: 0, games_played: 1, elo: 1918},
        ]

      assert {:ok, post_match_scores} == Match.record(pre_match_scores, "Dave", "Mary", "Dave")
    end

    test "with a draw" do
      pre_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      post_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 1, games_played: 1, elo: 1500},
          %{player: "Mary", wins: 0, losses: 0, draws: 1, games_played: 1, elo: 1500},
        ]

      assert {:ok, post_match_scores} == Match.record(pre_match_scores, "Dave", "Mary", :draw)
    end

    test "with a draw, with different starting elos" do
      pre_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1800},
          %{player: "Mary", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
        ]

      post_match_scores =
        [
          %{player: "Dave", wins: 0, losses: 0, draws: 1, games_played: 1, elo: 1789},
          %{player: "Mary", wins: 0, losses: 0, draws: 1, games_played: 1, elo: 1511},
        ]

      assert {:ok, post_match_scores} == Match.record(pre_match_scores, "Dave", "Mary", :draw)
    end

    test "returns error when player does not exist" do
      assert {:error, "Recording match failed. Player 'Dave' not found"} == Match.record([], "Dave", "Mary", "Dave")
    end
  end

end
