defmodule SquashScores.Rankings do
  alias SquashScores.Rankings.{Mapper, Match, NewPlayer}

  @scores_file Application.get_env(:squash_scores, :scores_file_location)
  @scores_dir Application.get_env(:squash_scores, :scores_dir)

  def get_or_create! do
    create_dir_and_file()
    with {:ok, file} <- File.read(@scores_file) do
      Mapper.from_scores_file!(file)
    end
  end

  def add_new_player(name) do
    get_or_create!()
    |> NewPlayer.add(name)
    |> Mapper.to_scores_file()
    |> write_new_player(name)
  end

  def record_match(winner, loser, outcome) do
    get_or_create!()
    |> Match.record(winner, loser, outcome)
    |> Mapper.to_scores_file()
    |> write_match()
  end

  defp write_match({:ok, new_scores}), do: File.write!(@scores_file, new_scores)
  defp write_match(error), do: error

  defp write_new_player({:ok, new_scores}, name) do
    File.touch!(@scores_file <> "_" <> String.downcase(name))
    File.write!(@scores_file, new_scores)
  end

  defp write_new_player(error, _), do: error

  defp create_dir_and_file do
    unless File.exists?(@scores_dir) do
      :ok = File.mkdir(@scores_dir)
    end

    unless File.exists?(@scores_file) do
      :ok = File.touch(@scores_file)
    end
  end
end
