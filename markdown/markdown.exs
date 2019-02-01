defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map(fn t -> process(t) end)
    |> Enum.join
    |> replace_tags
    |> patch
  end

  defp process("#" <> _ = t) do
    t
    |> parse_header_md_level
    |> enclose_with_header_tag
    |> replace_tags
  end

  defp process("* " <> rest) do
    "<li>" <> rest <> "</li>"
  end

  defp process(t) do
    "<p>" <> t <> "</p>"
  end

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)
    {to_string(String.length(h)), Enum.join(t, " ")}
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h" <> hl <> ">" <> htl <> "</h" <> hl <> ">"
  end

  defp replace_tags(string) do
    string
    |> String.replace(~r/\__(.*?)\__/, "<strong>\\g{1}</strong>")
    |> String.replace(~r/\_(.*?)\_/, "<em>\\g{1}</em>")
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
