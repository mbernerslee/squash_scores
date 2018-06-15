defmodule SquashScores.Rankings.NewPlayer do

  def add(current, name) do
    current
    |> Enum.reduce_while(:ok, fn %{player: current_name}, _acc -> name_taken(current_name, name) end)
    |> add(name, current)
  end

  defp name_taken(name, name), do: {:halt, {:error, "The player name '#{name}' is taken"}}
  defp name_taken(_, _), do: {:cont, :ok}

  defp add(:ok, name, current) do
    {:ok, Enum.reverse([%{player: name, wins: 0, losses: 0, draws: 0, games_played: 0, elo: 1500} | current])}
  end

  defp add(error, _, _), do: error
end
