defmodule SquashScores.Rankings.Match do

  def record(scores, winner, loser, winner) do
    with {:ok, [winner, loser | rest]} <- find_players([winner, loser], scores) do
      {winner, loser} = new_player_scores(winner, loser, winner)
      {:ok, [winner, loser | rest]}
    end
  end

  defp new_player_scores(winner, loser, winner) do
    {winner_elo, loser_elo} = elo([winner: winner.elo, loser: loser.elo])
    {update_winner(winner, winner_elo), update_loser(loser, loser_elo)}
  end

  defp update_winner(winner, new_elo) do
    %{winner | elo: new_elo, wins: winner.wins + 1, games_played: winner.games_played + 1}
  end

  defp update_loser(loser, new_elo) do
    %{loser | elo: new_elo, losses: loser.losses + 1, games_played: loser.games_played + 1}
  end

  defp elo([winner: winner_elo, loser: loser_elo], k_value \\ 32) do
    winner_elo_transformed = :math.pow(10, winner_elo / 400)
    loser_elo_transformed = :math.pow(10, winner_elo / 400)
    winner_elo = winner_elo + k_value * (1 - (winner_elo_transformed / (winner_elo_transformed + loser_elo_transformed)))
    loser_elo = loser_elo - k_value * (loser_elo_transformed / (winner_elo_transformed + loser_elo_transformed))
    {Kernel.trunc(winner_elo), Kernel.trunc(loser_elo)}
  end

  defp find_players(players_to_find, scores) do
    find_players([], [], scores, players_to_find)
  end

  defp find_players(found, others, rest, []) do
    {:ok, Enum.reverse(found) ++ others ++ rest}
  end

  defp find_players([], [], [], [name | _]) do
    {:error, "Recording match failed. Player '#{name}' not found"}
  end

  defp find_players(found, others, [%{player: name} = player | rest], [name | players_to_find]) do
    find_players([player | found], others, rest, players_to_find)
  end

  defp find_players(found, others, [player | rest], [_ | players_to_find]) do
    find_players(found, [player | others], rest, players_to_find)
  end
end
