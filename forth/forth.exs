defmodule Forth do
  @opaque evaluator :: any
  @instruction_set ["dup", "drop", "swap", "over"]

  defstruct command: "", instructions: %{}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{command: [], instructions: %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """

  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    lines = s
    |> String.downcase
    |> String.split(";")

    Enum.reduce(lines, ev, fn l, acc ->
      case String.starts_with?(l, ":") do
        true ->  define_instruction(ev, l)
        _ -> execute_cmd(acc, l)
      end
    end)
  end

  defp execute_cmd(ev, s) do
    res = s
    |> String.split(~r/[\pC\pZ]+/u)
    |> replace_custom(ev.instructions, [])
    |> do_eval(ev.command, ev.instructions)
    |> Enum.reverse()
    %Forth{command: res, instructions: ev.instructions}
  end

  defp replace_custom([cmd | rest], i, acc) do
    replace_custom(rest, i, acc ++ Map.get(i, cmd, [cmd]))
  end

  defp replace_custom([], _i, acc) do
    acc
  end

  defp clean_up(str) do

  end

  defp define_instruction(%Forth{instructions: instr} = ev, ": " <> line) do
    [cmd | rest] = line
      |> String.trim
      |> String.split(" ")

    if (Regex.match?(~r/\d\w*/, cmd)) do
      raise Forth.InvalidWord
    else
      %Forth{ ev | instructions: Map.put(instr, cmd, Enum.reject(rest, fn c -> c == ";" end))}
    end

  end

  defp do_eval(["+" | rest], [a, b | stack], i) do
    res = sum_string(a, b)
    do_eval(rest, [res] ++ stack, i)
  end

  defp do_eval(["-" | rest], [a, b | stack], i) do
    res = sub_string(b, a)
    do_eval(rest, [res] ++ stack, i)
  end

  defp do_eval(["/" | rest], ["0", b | stack], _i) do
    raise Forth.DivisionByZero
  end

  defp do_eval(["/" | rest], [a, b | stack], i) do
    res = div_string(b, a)
    do_eval(rest, [res] ++ stack, i)
  end

  defp do_eval(["*" | rest], [a, b | stack], i) do
    res = mul_string(a, b)
    do_eval(rest, [res] ++ stack, i)
  end

  defp do_eval([], res, _i) do
    res
  end

  defp do_eval(["dup" | rest], [a | stack], i) do
    do_eval(rest, [a, a] ++ stack, i)
  end

  defp do_eval(["drop" | rest], [a | stack], i) do
    do_eval(rest,  stack, i)
  end

  defp do_eval(["swap" | rest], [a, b | stack], i) do
    do_eval(rest, [b, a] ++ stack, i)
  end

  defp do_eval(["over" | rest], [a, b | stack], i) do
    do_eval(rest, [b, a, b] ++ stack, i)
  end

  defp do_eval([i | rest], [_ | []], _i)  when i in @instruction_set do
    raise Forth.StackUnderflow
  end

  defp do_eval([i | rest], [], _i) when i in @instruction_set do
    raise Forth.StackUnderflow
  end

  defp do_eval([a | rest], stack, i) do
    if is_valid?(a) do
      do_eval(rest, [a] ++ stack, i)
    else
      IO.inspect {a, rest, stack, i}, label: ">>>"
      raise Forth.UnknownWord
    end
  end

  def is_valid?(cmd) when cmd in @instruction_set, do: true
  def is_valid?(""), do: true

  def is_valid?(cmd) do
    IO.inspect cmd, label: "CMD>"
    case Integer.parse(cmd) do
      {_v, _} -> true
      :error -> false
    end
  end


  defp sum_string(a, b), do: to_string(String.to_integer(a) + String.to_integer(b))
  defp sub_string(a, b), do: to_string(String.to_integer(a) - String.to_integer(b))
  defp mul_string(a, b), do: to_string(String.to_integer(a) * String.to_integer(b))
  defp div_string(a, b), do: to_string(div(String.to_integer(a), String.to_integer(b)))


  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    String.trim(Enum.join(ev.command, " "))
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
