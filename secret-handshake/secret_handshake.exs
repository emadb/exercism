defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  use Bitwise

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    binary = code
    |> Integer.to_string(2)
    |> String.pad_leading(5, "0")
    |> String.graphemes

    words = wink(binary) ++ blink(binary) ++ close(binary) ++ jump(binary)
    reverse(binary, words)
  end

  defp wink([_, _, _, _, "1"]), do: ["wink"]
  defp wink(_), do: []

  defp blink([_, _, _, "1", _]), do: ["double blink"]
  defp blink(_), do: []

  defp close([_, _, "1", _, _]), do: ["close your eyes"]
  defp close(_), do: []

  defp jump([_, "1", _, _, _ ]), do: ["jump"]
  defp jump(_), do: []

  defp reverse(["1", _, _, _, _ ], words), do: Enum.reverse(words)
  defp reverse(_, words),  do: words
end
