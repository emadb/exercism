defmodule BankAccount do
  use GenServer

  defstruct amount: nil, status: nil
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    pid
  end

  def init(_) do
    {:ok, %BankAccount{amount: 0, status: :open}}
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.call(account, :close_bank)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.call(account, {:update, amount})
  end

  def handle_call(:balance, _from, %BankAccount{status: :closed} = state), do: {:reply, {:error, :account_closed}, state}
  def handle_call(:balance, _from, state), do: {:reply, state.amount, state}

  def handle_call({:update, _amount}, _from, %BankAccount{status: :closed} = state), do: {:reply, {:error, :account_closed}, state}
  def handle_call({:update, amount}, _from, state), do: {:reply, :ok, %BankAccount{state | amount: state.amount + amount}}

  def handle_call(:close_bank, _from, state), do: {:reply, :ok, %BankAccount{state | status: :closed}}


  def foo() do
    :bar
  end
end
