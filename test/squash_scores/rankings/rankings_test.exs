defmodule SquashScores.RankingsTest do
  use ExUnit.Case
  alias SquashScores.Rankings

  @scores_file_location Application.get_env(:squash_scores, :scores_file_location)

  setup do
    if {:error, :enoent} == File.ls("priv/static") do
      File.mkdir("priv/static")
    end
    dir = Application.get_env(:squash_scores, :scores_dir)
    {:ok, _} = File.rm_rf(dir)
    File.mkdir(dir)
    File.touch!(@scores_file_location)

    on_exit fn -> {:ok, _} = File.rm_rf(dir) end
  end

  describe "get!/0" do
    test "gets parsed contents of the scores file" do
      assert [] == Rankings.get!()

      File.write!(@scores_file_location, "Dave,0,0,0,0,1500\n")
      assert [%{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500}] = Rankings.get!()
    end
  end

  describe "add_new_player/1" do
    test "writes a new row to the scores file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file_location)
    end

    test "player names must be unique in the scores file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert {:error, "The player name 'Dave' is taken"} == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file_location)
    end

    test "creates empty player history file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert "" == File.read!(@scores_file_location <> "_dave")
    end
  end

  describe "record_match/1" do
    test "with a winner and a loser" do
      :ok = Rankings.add_new_player("Dave")
      :ok = Rankings.add_new_player("Mary")
      :ok = Rankings.add_new_player("Jim")

      Rankings.record_match("Dave", "Mary", "Dave")

      assert [
        %{player: "Dave", wins: 1, losses: 0, draws: 0, games_played: 1, elo: 1516},
        %{player: "Mary", wins: 0, losses: 1, draws: 0, games_played: 1, elo: 1484},
        %{player: "Jim", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
      ] = Rankings.get!()

    end
  end
end
