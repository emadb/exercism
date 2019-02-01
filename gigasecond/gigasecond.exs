defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from({{year, month, day}, {hours, minutes, seconds}}) do
    %DateTime{
      year: year, month: month, day: day,
      hour: hours, minute: minutes, second: seconds,
      zone_abbr: "UTC", utc_offset: 0, std_offset: 0, time_zone: "Etc/UTC"
    }
    |> DateTime.add(1_000_000_000, :second)
    |> (&({{&1.year, &1.month, &1.day}, {&1.hour, &1.minute, &1.second}})).()

  end
end


995491
