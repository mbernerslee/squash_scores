defmodule SquashScores.Rankings.MapperTest do
  use ExUnit.Case, async: true
  alias SquashScores.Rankings.Mapper

  describe "from_scores_file!/1" do
    test "with a string read from the scores file, converts to maps" do
      assert [
        %{player: "Dave", wins: 1, losses: 0, draws: 0, elo: 1516},
        %{player: "Mary", wins: 0, losses: 1, draws: 0, elo: 1484},
        %{player: "Jim", wins: 0, losses: 0, draws: 0, elo: 1500},
      ] == Mapper.from_scores_file!("Dave,1,0,0,1516\nMary,0,1,0,1484\nJim,0,0,0,1500\n")
    end
  end

  describe "to_scores_file/1" do
    test "with ok and maps, parses to csv string format for scores file" do
      assert {:ok, "Dave,1,0,0,1516\nMary,0,1,0,1484\nJim,0,0,0,1500\n"} ==
        Mapper.to_scores_file({:ok, [
          %{player: "Dave", wins: 1, losses: 0, draws: 0, elo: 1516},
          %{player: "Mary", wins: 0, losses: 1, draws: 0, elo: 1484},
          %{player: "Jim", wins: 0, losses: 0, draws: 0, elo: 1500},
        ]})
    end

    test "with error, returns it" do
      assert {:error, "oops"} == Mapper.to_scores_file({:error, "oops"})
    end
  end
end
