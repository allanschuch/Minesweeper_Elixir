defmodule MinesweeperTest do
  use ExUnit.Case
  doctest Minesweeper

  test "get_arr" do
    assert Minesweeper.get_arr([1,2,3,4],0) == 1
    assert Minesweeper.get_arr([],3) == nil
  end

  test "update_arr" do
    assert Minesweeper.update_arr([1,2,3,4],0,5) == [5,2,3,4]
    assert Minesweeper.update_arr([1,2,3,4],2,5) == [1,2,5,4]
  end

  test "get_pos" do
    assert Minesweeper.get_pos([[1,2,3],[1,2,3],[1,2,3]],0,0) == 1
    assert Minesweeper.get_pos([[1,2,3],[1,2,3],[1,2,3]],0,1) == 2
  end

  test "update_pos" do
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],0,0,5) == [[5,2,3],[1,2,3],[1,2,3]]
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],0,1,5) == [[1,5,3],[1,2,3],[1,2,3]]
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],1,2,5) == [[1,2,3],[1,2,5],[1,2,3]]
  end

  test "is_mine" do
    mines_board = [[false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, true , false, false, false, false],
                   [false, false, false, false, false, true, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false]]
    assert Minesweeper.is_mine(mines_board,4,4) == true
    assert Minesweeper.is_mine(mines_board,3,4) == false
  end

  test "is_valid_pos" do
    assert Minesweeper.is_valid_pos(9,8,9) == true
    assert Minesweeper.is_valid_pos(9,9,9) == true
    assert Minesweeper.is_valid_pos(6,8,9) == false
    assert Minesweeper.is_valid_pos(9,12,9) == false
    assert Minesweeper.is_valid_pos(9,9,12) == false
  end

  test "valid_moves" do
    assert Minesweeper.valid_moves()
  end
end
