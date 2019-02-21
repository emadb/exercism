defmodule Bowling do
  defstruct current_frame: {0, 0}, rolls: [], frame_count: 0

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %Bowling{current_frame: {:empty, :empty}, rolls: [], frame_count: 1}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(_game, roll) when roll < 0 do
    {:error, "Negative roll is invalid"}
  end

  def roll(_game, roll) when roll > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end


  def roll(%Bowling{current_frame: {:empty, :empty}, rolls: rolls} = game, roll) do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll]}
  end

  def roll(%Bowling{current_frame: {10, :empty}, rolls: rolls, frame_count: count} = game, roll) do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1 }
  end

  def roll(%Bowling{current_frame: {f1, :empty}}, roll) when f1 + roll > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(%Bowling{current_frame: {f1, :empty}, rolls: rolls} = game, roll) do
    %Bowling{game | current_frame: {f1, roll}, rolls: rolls ++ [roll]}
  end

  def roll(%Bowling{current_frame: {f1, f2}, rolls: rolls, frame_count: count} = game, roll) when count == 10 and f1 + f2 == 10 do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1}
  end

  def roll(%Bowling{current_frame: {f1, f2}, frame_count: count}, _roll) when count >= 10 and f1 + f2 < 10 do
    {:error, "Cannot roll after game is over"}
  end

  def roll(%Bowling{current_frame: {_f1, _f2}, rolls: rolls, frame_count: count} = game, roll) do
   %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1}
  end


  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(%Bowling{rolls: []}), do: {:error, "Score cannot be taken until the end of the game"}

  def score(%Bowling{current_frame: {10, :empty}, rolls: rolls, frame_count: count}) when count == 10 or count == 11 do
    [10, f1, f2 | _rest] = Enum.reverse(rolls)
    if (f1 + f2 == 10 and f1 != 10 and f2 != 10) do
      calc_score(rolls, 0)
    else
      {:error, "Score cannot be taken until the end of the game"}
    end
  end

  def score(%Bowling{current_frame: {f1, f2}, frame_count: 10}) when f1 + f2 == 10, do: {:error, "Score cannot be taken until the end of the game"}
  def score(%Bowling{frame_count: count}) when count < 10, do: {:error, "Score cannot be taken until the end of the game"}

  def score(game) do
    calc_score(game.rolls, 0)
  end

  defp calc_score([10, f2, f3], score) do
    score + 10 + f2 + f3
  end

  defp calc_score([f1, f2, f3], score) do
    score + f1 + f2 + f3
  end

  defp calc_score([], score) do
    score
  end

  defp calc_score([10, f2, f3 | rest], score) do
    calc_score([f2 | [f3 | rest]], 10 + score + f2 + f3)
  end

  defp calc_score([f1, f2, f3 | rest], score) when f1 + f2 == 10 do
    calc_score([f3 | rest], 10 + score + f3)
  end

  defp calc_score([f1, f2 | rest], score) do
    calc_score(rest, score + f1 + f2)
  end



end
