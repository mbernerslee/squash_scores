defmodule SquashScores.Rankings.Mapper do

  def from_scores_file!(scores_file_contents) do
    scores_file_contents
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&from_scores_file_row/1)
  end

  def to_scores_file({:ok, scores}), do: {:ok, csv(scores)}
  def to_scores_file(error), do: error

  defp csv(scores) do
    scores
    |> Enum.reduce([], &(csv(&1, &2)))
    |> Enum.reverse()
    |> Enum.join()
  end

  defp csv(%{player: player, wins: wins, losses: losses, draws: draws, games_played: games_played, elo: elo}, acc) do
    ["#{player},#{wins},#{losses},#{draws},#{games_played},#{elo}\n" | acc]
  end

  defp from_scores_file_row(row) do
    [player, wins, losses, draws, games_played, elo] = String.split(row, ",")
    %{
      player: player,
      wins: String.to_integer(wins),
      losses: String.to_integer(losses),
      draws: String.to_integer(draws),
      games_played: String.to_integer(games_played),
      elo: String.to_integer(elo),
    }
  end
end
