defmodule RobotSimulator do
  defstruct direction: nil, position: nil
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create() do
    %RobotSimulator{direction: :north, position: {0, 0}}
  end


  def create(direction, _) when direction not in [:north, :south, :east, :west] do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_number(x) and is_number(y) do
    %RobotSimulator{direction: direction, position: {x, y}}
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

  defp execute_instruction({:error, "invalid instruction"} = error, _instruction), do: error
  defp execute_instruction(_robot, instruction) when instruction not in ["L", "R", "A"] do
    {:error, "invalid instruction"}
  end

  defp execute_instruction(robot, "A"), do: advance(robot)
  defp execute_instruction(robot, "L"), do: turn_left(robot)
  defp execute_instruction(robot, "R"), do: turn_right(robot)

  defp advance(%RobotSimulator{direction: :north, position: {x, y}}), do: %RobotSimulator{direction: :north, position: {x, y + 1}}
  defp advance(%RobotSimulator{direction: :south, position: {x, y}}), do: %RobotSimulator{direction: :south, position: {x, y - 1}}
  defp advance(%RobotSimulator{direction: :east, position: {x, y}}), do: %RobotSimulator{direction: :east, position: {x + 1, y}}
  defp advance(%RobotSimulator{direction: :west, position: {x, y}}), do: %RobotSimulator{direction: :west, position: {x - 1, y}}

  defp turn_left(%RobotSimulator{direction: direction} = robot) do
    new_direction =
      case direction do
        :north -> :west
        :west -> :south
        :south -> :east
        :east -> :north
      end

    %RobotSimulator{robot | direction: new_direction}
  end

  defp turn_right(%RobotSimulator{direction: direction} = robot) do
    new_direction =
      case direction do
        :north -> :east
        :west -> :north
        :south -> :west
        :east -> :south
      end

    %RobotSimulator{robot | direction: new_direction}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%RobotSimulator{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%RobotSimulator{position: position}) do
    position
  end
end
