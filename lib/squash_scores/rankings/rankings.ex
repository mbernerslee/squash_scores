defmodule SquashScores.Rankings do
  alias SquashScores.Rankings.{Mapper, Match, NewPlayer}

  @scores_file_location Application.get_env(:squash_scores, :scores_file_location)

  def get!, do: @scores_file_location |> File.read!() |> Mapper.from_scores_file!()

  def add_new_player(name) do
    get!()
    |> NewPlayer.add(name)
    |> Mapper.to_scores_file()
    |> write_new_player(name)
  end

  def record_match(winner, loser, outcome) do
    get!()
    |> Match.record(winner, loser, outcome)
    |> Mapper.to_scores_file()
    |> write_match()
  end

  defp write_match({:ok, new_scores}) do
    File.write!(@scores_file_location, new_scores)
  end

  defp write_new_player({:ok, new_scores}, name) do
    File.touch!(@scores_file_location <> "_" <> String.downcase(name))
    File.write!(@scores_file_location, new_scores)
  end

  defp write_new_player(error, _), do: error
end
