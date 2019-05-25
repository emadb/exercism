defmodule Bowling do
  @spare 10
  @strike 10
  @tenth_frame 10
  defstruct current_frame: {0, 0}, rolls: [], frame_count: 0

  @spec start() :: any
  def start do
    %Bowling{current_frame: {:empty, :empty}, rolls: [], frame_count: 1}
  end

  def roll(%Bowling{current_frame: {:empty, :empty}, rolls: rolls} = game, roll) do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll]}
  end

  def roll(%Bowling{current_frame: {@strike, :empty}, rolls: rolls, frame_count: count} = game, roll) do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1 }
  end

  def roll(%Bowling{current_frame: {f1, :empty}, rolls: rolls} = game, roll) do
    %Bowling{game | current_frame: {f1, roll}, rolls: rolls ++ [roll]}
  end

  def roll(%Bowling{current_frame: {f1, f2}, rolls: rolls, frame_count: count} = game, roll) when count == @tenth_frame and f1 + f2 == @spare do
    %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1}
  end

  def roll(%Bowling{current_frame: {_f1, _f2}, rolls: rolls, frame_count: count} = game, roll) do
   %Bowling{game | current_frame: {roll, :empty}, rolls: rolls ++ [roll], frame_count: count + 1}
  end

  def score(%Bowling{current_frame: {@strike, :empty}, rolls: rolls, frame_count: count}) when count == @tenth_frame or count == @tenth_frame + 1 do
    calc_score(rolls, 0)
  end

  def score(game) do
    calc_score(game.rolls, 0)
  end

  defp calc_score([@strike, f2, f3], score) do
    score + @strike + f2 + f3
  end

  defp calc_score([f1, f2, f3], score) do
    score + f1 + f2 + f3
  end

  defp calc_score([], score) do
    score
  end

  defp calc_score([@strike, f2, f3 | rest], score) do
    calc_score([f2 | [f3 | rest]], @strike + score + f2 + f3)
  end

  defp calc_score([f1, f2, f3 | rest], score) when f1 + f2 == @spare do
    calc_score([f3 | rest], @spare + score + f3)
  end

  defp calc_score([f1, f2 | rest], score) do
    calc_score(rest, score + f1 + f2)
  end

end
