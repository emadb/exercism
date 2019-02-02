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
    |> Enum.map_join(&process_line/1)
    |> replace_tags()
    |> patch()
  end

  defp process_line("#" <> _ = header) do
    header
    |> parse_header_md_level()
    |> enclose_with_header_tag()
    |> replace_tags()
  end

  defp process_line("* " <> rest) do
    "<li>#{rest}</li>"
  end

  defp process_line(text) do
    "<p>#{text}</p>"
  end

  defp parse_header_md_level(header) do
    [h | t] = String.split(header)
    {to_string(String.length(h)), Enum.join(t, " ")}
  end

  defp enclose_with_header_tag({header_size, header_text}) do
    "<h#{header_size}>#{header_text}</h#{header_size}>"
  end

  defp replace_tags(line) do
    line
    |> String.replace(~r/\__(.*?)\__/, "<strong>\\g{1}</strong>")
    |> String.replace(~r/\_(.*?)\_/, "<em>\\g{1}</em>")
  end

  defp patch(line) do
    line
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
