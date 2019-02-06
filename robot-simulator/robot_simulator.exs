defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create() do
    {:north, {0, 0}}
  end


  def create(direction, _) when direction not in [:north, :south, :east, :west] do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_number(x) and is_number(y) do
    {direction, {x, y}}
  end

  def create(_direction, _position) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    String.graphemes(instructions)
    |> Enum.reduce(robot, fn i, r ->
      execute_instruction(r, i)
    end)
  end

  defp execute_instruction({:north, {x, y}}, "A"), do: {:north, {x, y + 1}}
  defp execute_instruction({:south, {x, y}}, "A"), do: {:south, {x, y - 1}}
  defp execute_instruction({:east, {x, y}}, "A"), do: {:east, {x + 1, y}}
  defp execute_instruction({:west, {x, y}}, "A"), do: {:west, {x - 1, y}}

  defp execute_instruction({:north, {x, y}}, "L"), do: {:west, {x, y}}
  defp execute_instruction({:south, {x, y}}, "L"), do: {:east, {x, y}}
  defp execute_instruction({:east, {x, y}}, "L"), do: {:north, {x, y}}
  defp execute_instruction({:west, {x, y}}, "L"), do: {:south, {x, y}}

  defp execute_instruction({:north, {x, y}}, "R"), do: {:east, {x, y}}
  defp execute_instruction({:south, {x, y}}, "R"), do: {:west, {x, y}}
  defp execute_instruction({:east, {x, y}}, "R"), do: {:south, {x, y}}
  defp execute_instruction({:west, {x, y}}, "R"), do: {:north, {x, y}}

  defp execute_instruction({:error, "invalid instruction"} = error, _instruction), do: error
  defp execute_instruction(_robot, instruction) when instruction not in ["L", "R", "A"] do
    {:error, "invalid instruction"}
  end


  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction({direction, _}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position({_, position}) do
    position
  end
end
