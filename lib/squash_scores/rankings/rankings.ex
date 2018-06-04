defmodule SquashScores.Rankings do
  alias SquashScores.Rankings.{Mapper, NewPlayer}

  @scores_file_location Application.get_env(:squash_scores, :scores_file_location)

  def get!, do: Mapper.from_scores_file!(read!())

  def add_new_player(name) do
    get!()
    |> NewPlayer.add(name)
    |> Mapper.to_scores_file()
    |> add_new_player(name)
  end

  def record_match(winner, loser, winner, k_value \\ 32) do
    #[winner, loser | rest] = get!([winner, loser])
    #[winner, loser] = new_rankings(winner, loser, winner, k_value)
    #update_rankings([winner, loser | rest])
    get!()
    |> Match.record(winner, loser, winner, k_value)
  end

  defp add_new_player({:ok, new_scores}, name) do
    File.touch!(@scores_file_location <> "_" <> String.downcase(name))
    File.write!(@scores_file_location, new_scores)
  end

  defp add_new_player(error, _), do: error

  defp update_rankings(rankings), do: update_rankings("", rankings)

  defp update_rankings(acc, []) do
    File.write!(@scores_file_location, acc)
  end

  defp update_rankings(acc, [ranking | rest]) do
    acc = acc <>
      "#{ranking.player},#{ranking.wins},#{ranking.losses},#{ranking.draws},#{ranking.games_played},#{ranking.elo}\n"
    update_rankings(acc, rest)
  end

  defp new_rankings(winner, loser, winner, k_value) do
    transformed_winner_elo = :math.pow(10, winner.elo / 400)
    transformed_loser_elo = :math.pow(10, loser.elo / 400)

    expected_winner_score = transformed_winner_elo / (transformed_winner_elo + transformed_loser_elo)
    expected_loser_score = transformed_loser_elo / (transformed_winner_elo + transformed_loser_elo)

    winner_elo = Kernel.trunc(winner.elo + k_value * (1 - expected_winner_score))
    loser_elo = Kernel.trunc(loser.elo + k_value * (0 - expected_loser_score))

    winner =
      winner
      |> Map.update!(:elo, fn _ -> winner_elo end)
      |> Map.update!(:wins, fn wins -> wins + 1 end)
      |> Map.update!(:games_played, fn games_played -> games_played + 1 end)

    loser =
      loser
      |> Map.update!(:elo, fn _ -> loser_elo end)
      |> Map.update!(:losses, fn losses -> losses + 1 end)
      |> Map.update!(:games_played, fn games_played -> games_played + 1 end)

    [winner, loser]
  end

  defp get!(players_to_find) do
    players = get!()
    get!([], [], players, players_to_find)
  end

  defp get!(found, others, rest, []) do
    Enum.reverse(found) ++ others ++ rest
  end

  defp get!(found, others, [%{player: name} = player | rest], [name | rest_2]) do
    get!([player | found], others, rest, rest_2)
  end

  defp get!(found, others, [player | rest], [_ | rest_2]) do
    get!(found, [player | others], rest, rest_2)
  end

  defp read!, do: File.read!(@scores_file_location)
end
