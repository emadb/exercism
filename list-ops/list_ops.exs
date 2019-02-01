defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(list), do: do_count(list, 0)
  defp do_count([], l), do: l
  defp do_count([_h | t], l), do: do_count(t, l + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])
  defp do_reverse([h | t], acc), do: do_reverse(t, [h | acc])
  defp do_reverse([], acc), do: acc

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f)
  defp do_map([h | t], f), do: [f.(h) | do_map(t, f)]
  defp do_map([], _f), do: []

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f)
  defp do_filter([h | t], f) do
    case f.(h) do
      true -> [h | do_filter(t, f)]
      false -> do_filter(t, f)
    end
  end
  defp do_filter([], _f), do: []

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f), do: do_reduce(l, acc, f)
  defp do_reduce([h | t], acc, f), do: do_reduce(t, f.(h, acc), f)
  defp do_reduce([], acc, _f), do: acc

  @spec append(list, list) :: list
  def append(a, b), do: do_append(a, b)
  defp do_append([], b), do: b
  defp do_append(a, []), do: a
  defp do_append([h |t], b), do: [h | do_append(t, b)]

  @spec concat([[any]]) :: [any]
  def concat(ll), do: do_concat(ll)
  defp do_concat([]), do: []
  defp do_concat([[] | lists]), do: do_concat(lists)
  defp do_concat([[x | xs] | lists]), do: [x | do_concat([xs | lists])]
end
