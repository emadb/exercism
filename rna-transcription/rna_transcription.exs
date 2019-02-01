defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &to_rna_single/1)
  end

  defp to_rna_single(?G), do: ?C
  defp to_rna_single(?C), do: ?G
  defp to_rna_single(?T), do: ?A
  defp to_rna_single(?A), do: ?U
end
