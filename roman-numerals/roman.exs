defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) when number <= 3 do
    String.duplicate("I", number)
  end

  def numerals(number) when number == 4 do
    "IV"
  end

  def numerals(number) when number == 9 do
    "IX"
  end

  def numerals(number) when number >= 1000 do
    "M" <> numerals(number - 1000)
  end

  def numerals(number) when number >= 900 do
    "CM" <> numerals(number - 900)
  end

  def numerals(number) when number >= 500 do
    "D" <> numerals(number - 500)
  end

  def numerals(number) when number >= 400 do
    "CD" <> numerals(number - 400)
  end

  def numerals(number) when number >= 100 do
    "C" <> numerals(number - 100)
  end

  def numerals(number) when number >= 90 do
    "XC" <> numerals(number - 90)
  end

  def numerals(number) when number >= 50 do
    "L" <> numerals(number - 50)
  end

  def numerals(number) when number >= 40 do
    "XL" <> numerals(number - 40)
  end

  def numerals(number) when number >= 10 do
    "X" <> numerals(number - 10)
  end

  def numerals(number) when number >= 5 do
    "V" <> numerals(number - 5)
  end


end
