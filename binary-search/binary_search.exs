defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers))
  end

  defp do_search(numbers, key, l, r) when l > r, do: :not_found

  defp do_search(numbers, key, l, r) do
    middle_index = div(r + l, 2)
    cond do
      middle_index >= tuple_size(numbers) -> :not_found
      elem(numbers, middle_index) == key -> {:ok, middle_index}
      elem(numbers, middle_index) > key -> do_search(numbers, key, l, middle_index - 1)
      elem(numbers, middle_index) < key -> do_search(numbers, key, middle_index + 1 , r)
    end
  end
end
