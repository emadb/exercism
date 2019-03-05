defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when hour < 0, do: new(24 + hour, minute)
  def new(hour, minute) when minute < 0, do: new(hour - 1, 60 + minute)

  def new(hour, minute) do
    normalized_minute = rem(minute, 60)
    normalized_hour = rem(hour + div(minute, 60), 24)

    %Clock{hour: normalized_hour, minute: normalized_minute}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end

defimpl String.Chars, for: Clock do
  defp format(v) do
    v |> Integer.to_string() |> String.pad_leading(2, "0")
  end

  def to_string(c) do
    "#{format(c.hour)}:#{format(c.minute)}"
  end
end
