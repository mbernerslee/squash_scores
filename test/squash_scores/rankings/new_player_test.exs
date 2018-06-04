defmodule SquashScores.Rankings.NewPlayerTest do
  use ExUnit.Case
  alias SquashScores.Rankings.NewPlayer

  describe "add/1" do
    test "with player name free, adds the player" do
      assert {:ok, [%{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500}]} == NewPlayer.add([], "Dave")

      assert {:ok, [
        %{player: "Mary", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584},
        %{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
      ]} == NewPlayer.add([%{player: "Mary", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584}], "Dave")
    end

    test "with player name taken, returns error, does not add" do
      assert {:error, "The player name 'Mary' is taken"} == NewPlayer.add([%{player: "Mary", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584}], "Mary")

      assert {:error, "The player name 'Dave' is taken"} ==
        NewPlayer.add([
          %{player: "Jim", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584},
          %{player: "Sarah", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584},
          %{player: "Dave", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584},
          %{player: "Mary", wins: 4, losses: 2, draws: 1, games_played: 7, elo: 1584},
        ], "Dave")
    end
  end
end
