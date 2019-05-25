if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("bowling.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule BowlingTest do
  use ExUnit.Case

  defp roll_reduce(game, rolls) do
    Enum.reduce(rolls, game, fn roll, game -> Bowling.roll(game, roll) end)
  end

  test "should be able to score a game with all zeros" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 0
  end

  test "should be able to score a game with no strikes or spares" do
    game = Bowling.start()
    rolls = [3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 90
  end

  test "a spare followed by zeros is worth ten points" do
    game = Bowling.start()
    rolls = [6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 10
  end

  test "points scored in the roll after a spare are counted twice" do
    game = Bowling.start()
    rolls = [6, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 16
  end

  test "consecutive spares each get a one roll bonus" do
    game = Bowling.start()
    rolls = [5, 5, 3, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 31
  end

  test "a spare in the last frame gets a one roll bonus that is counted once" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 7]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 17
  end

  test "a strike earns ten points in a frame with a single roll" do
    game = Bowling.start()
    rolls = [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 10
  end

  test "points scored in the two rolls after a strike are counted twice as a bonus" do
    game = Bowling.start()
    rolls = [10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 26
  end

  test "consecutive strikes each get the two roll bonus" do
    game = Bowling.start()
    rolls = [10, 10, 10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 81
  end


  test "a strike in the last frame gets a two roll bonus that is counted once" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 1]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 18
  end

  test "rolling a spare with the two roll bonus does not get a bonus roll" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 3]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 20
  end


  test "strikes with the two roll bonus do not get bonus rolls" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 30
  end


  test "a strike with the one roll bonus after a spare in the last frame does not get a bonus" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 10]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 20
  end


  test "all strikes is a perfect game" do
    game = Bowling.start()
    rolls = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 300
  end

  test "two bonus rolls after a strike in the last frame can score more than 10 points if one is a strike" do
    game = Bowling.start()
    rolls = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 6]
    game = roll_reduce(game, rolls)
    assert Bowling.score(game) == 26
  end
end
