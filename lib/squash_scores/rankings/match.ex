defmodule SquashScores.Rankings.Match do

  # For info on the maths see:
  # https://metinmediamath.wordpress.com/2013/11/27/how-to-calculate-the-elo-rating-including-example/

  @k_value 32

  def record(scores, player_1, player_2, outcome) do
    with {:ok, [player_1, player_2 | rest]} <- find_players([player_1, player_2], scores) do
      {player_1, player_2} = new_player_scores(player_1, player_2, outcome)
      {:ok, [player_1, player_2 | rest]}
    end
  end

  defp new_player_scores(player_1, player_2, :draw) do
    {player_1_elo, player_2_elo} = elo({player_1.elo, player_2.elo}, {0.5, 0.5})
    {update_drawer(player_1, player_1_elo), update_drawer(player_2, player_2_elo)}
  end

  defp new_player_scores(%{player: winner_name} = winner, loser, winner_name) do
    {winner_elo, loser_elo} = elo({winner.elo, loser.elo})
    {update_winner(winner, winner_elo), update_loser(loser, loser_elo)}
  end

  defp update_drawer(drawer, elo) do
    %{drawer | elo: elo, draws: drawer.draws + 1, games_played: drawer.games_played + 1}
  end

  defp update_winner(winner, elo) do
    %{winner | elo: elo, wins: winner.wins + 1, games_played: winner.games_played + 1}
  end

  defp update_loser(loser, elo) do
    %{loser | elo: elo, losses: loser.losses + 1, games_played: loser.games_played + 1}
  end

  defp elo({player_1_elo, player_2_elo}, {player_1_s_value, player_2_s_value} \\ {1, 0}) do
    {elo(player_1_elo, player_2_elo, player_1_s_value), elo(player_2_elo, player_1_elo, player_2_s_value)}
  end

  defp elo(current, opponent_current, s_value) do
    transformed = transformed_elo(current)
    opponent_transformed = transformed_elo(opponent_current)
    round(current + @k_value * (s_value - (transformed / (transformed + opponent_transformed))))
  end

  defp transformed_elo(elo), do: :math.pow(10, elo / 400)

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

  defp find_players(found, others, [player | rest], players_to_find) do
    find_players(found, [player | others], rest, players_to_find)
  end

  defp find_players(found, others, [], [player_to_find]) do
    find_players(found, [], others, [player_to_find])
  end
end
