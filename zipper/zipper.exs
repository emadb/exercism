defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """

  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(bt) do
    {bt, []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree({_, rest} = z) do
    {tree, []} = Enum.reduce(rest, z, fn(_, z) -> up(z) end)
    tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value({focus, _}) do
    focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left({focus, rest}) do
    if focus.left do
      {focus.left, [{:right, focus.value, focus.right} | rest]}
    else
      nil
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right({focus, rest}) do
    if focus.right do
      {focus.right, [{:left, focus.value, focus.left} | rest]}
    else
      nil
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up({_, []}), do: nil
  def up({focus, rest}) do
    [{side, value, subtree} | new_rest] = rest
    if side == :left do
      {%BinTree{value: value, left: subtree, right: focus}, new_rest}
    else
      {%BinTree{value: value, left: focus, right: subtree}, new_rest}
    end

  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value({focus, rest}, v) do
    {%{focus | value: v}, rest}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left({focus, rest}, l) do
    {%{focus | left: l}, rest}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right({focus, rest}, r) do
    {%{focus | right: r}, rest}
  end
end
