defmodule SquashScores.RankingsTest do
  use ExUnit.Case
  alias SquashScores.Rankings

  @scores_file Application.get_env(:squash_scores, :scores_file_location)
  @scores_dir Application.get_env(:squash_scores, :scores_dir)

  setup do
    {:ok, _} = File.rm_rf(@scores_dir)
    File.mkdir(@scores_dir)
    File.touch!(@scores_file)

    on_exit fn -> {:ok, _} = File.rm_rf(@scores_dir) end
  end

  describe "get/0" do
    test "gets parsed contents of the scores file" do
      assert {:ok, []} == Rankings.get()

      File.write!(@scores_file, "Dave,0,0,0,0,1500\n")
      assert {:ok, [%{player: "Dave", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500}]} = Rankings.get()
    end
  end

  describe "add_new_player/1" do
    test "writes a new row to the scores file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file)
    end

    test "player names must be unique in the scores file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert {:error, "The player name 'Dave' is taken"} == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file)
    end

    test "creates empty player history file" do
      assert :ok == Rankings.add_new_player("Dave")
      assert "" == File.read!(@scores_file <> "_dave")
    end

    test "creates the dir & file if it does not exist" do
      {:ok, _} = File.rm_rf(@scores_dir)
      assert :ok == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file)
    end

    test "creates file if it does not exist" do
      {:ok, _} = File.rm_rf(@scores_file)
      assert :ok == Rankings.add_new_player("Dave")
      assert "Dave,0,0,0,0,1500\n" == File.read!(@scores_file)
    end
  end

  describe "record_match/1" do
    test "with a winner and a loser" do
      :ok = Rankings.add_new_player("Dave")
      :ok = Rankings.add_new_player("Mary")
      :ok = Rankings.add_new_player("Jim")

      Rankings.record_match("Dave", "Mary", "Dave")

      assert {:ok, [
        %{player: "Dave", wins: 1, losses: 0, draws: 0, games_played: 1, elo: 1516},
        %{player: "Mary", wins: 0, losses: 1, draws: 0, games_played: 1, elo: 1484},
        %{player: "Jim", wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500},
      ]} = Rankings.get()
    end

    test "with players that do not exist" do
      assert {:error, "Recording match failed. Player 'Dave' not found"} == Rankings.record_match("Dave", "Mary", "Dave")
    end

    test "errors gracefully if dir & file if it does not exist" do
      :ok = Rankings.add_new_player("Dave")
      :ok = Rankings.add_new_player("Mary")
      {:ok, _} = File.rm_rf(@scores_dir)
      assert {:error, "No scores file found. Game not recorded"} = Rankings.record_match("Dave", "Mary", "Dave")
    end

    test "errors gracefully if file does not exist" do
      :ok = Rankings.add_new_player("Dave")
      :ok = Rankings.add_new_player("Mary")
      {:ok, _} = File.rm_rf(@scores_file)
      assert {:error, "No scores file found. Game not recorded"} = Rankings.record_match("Dave", "Mary", "Dave")
    end
  end
end
