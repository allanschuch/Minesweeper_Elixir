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
    assert Minesweeper.get_pos([[1,2,3],[1,2,3],[1,2,3]],{0,0}) == 1
    assert Minesweeper.get_pos([[1,2,3],[1,2,3],[1,2,3]],{0,1}) == 2
  end

  test "update_pos" do
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],{0,0},5) == [[5,2,3],[1,2,3],[1,2,3]]
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],{0,1},5) == [[1,5,3],[1,2,3],[1,2,3]]
    assert Minesweeper.update_pos([[1,2,3],[1,2,3],[1,2,3]],{1,2},5) == [[1,2,3],[1,2,5],[1,2,3]]
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
    assert Minesweeper.is_mine(mines_board,{4,4}) == true
    assert Minesweeper.is_mine(mines_board,{3,4}) == false
  end

  test "is_valid_pos" do
    assert Minesweeper.is_valid_pos(9,{8,7}) == true
    assert Minesweeper.is_valid_pos(10,{9,9}) == true
    assert Minesweeper.is_valid_pos(6,{8,9}) == false
    assert Minesweeper.is_valid_pos(9,{12,8}) == false
    assert Minesweeper.is_valid_pos(9,{7,12}) == false
    assert Minesweeper.is_valid_pos(1,{0,0}) == true
    assert Minesweeper.is_valid_pos(1,{-1,0}) == false
  end

  test "valid_moves" do
    assert Minesweeper.valid_moves(3,{0,2}) == [{0,1},{1,1},{1,2}]
  end

  test "conta_minas_adj" do
    mines_board = [[false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, true , false, false, false, false],
                   [false, false, false, false, false, true, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false],
                   [false, false, false, false, false, false, false, false, false]]
    assert Minesweeper.conta_minas_adj(mines_board,{5,4}) == 2
    assert Minesweeper.conta_minas_adj(mines_board,{4,3}) == 1
    assert Minesweeper.conta_minas_adj(mines_board,{1,3}) == 0
  end

  test "get_tam" do
    mines_board = [[false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, true , false, false, false, false],
                    [false, false, false, false, false, true, false, false, false],
                    [false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, false, false, false, false, false],
                    [false, false, false, false, false, false, false, false, false]]
    assert Minesweeper.get_tam(mines_board) == 9
    assert Minesweeper.get_tam([[false, false, false],
                    [false, false, false],
                    [false, false, false]]) == 3
  end

  test "abre_posicao" do
    mines_board = [[false, false, false],
                  [false, false, false],
                  [false, false, false]]
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_posicao(tab,mines_board,{0,0}) == [["0", "-", "-"],
                                                              ["-", "-", "-"],
                                                              ["-", "-", "-"]]
    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_posicao(tab,mines_board,{0,0}) == [["2", "-", "-"],
                                                              ["-", "-", "-"],
                                                              ["-", "-", "-"]]
    mines_board = [[false, false, false],
                  [false, false, false],
                  [false, false, false]]
    tab = [["0", "-", "-"],
          ["-", "2", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_posicao(tab,mines_board,{1,1}) == [["0", "-", "-"],
                                                              ["-", "2", "-"],
                                                              ["-", "-", "-"]]
    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    tab = [["2", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_posicao(tab,mines_board,{1,1}) == [["2", "-", "-"],
                                                              ["-", "*", "-"],
                                                              ["-", "-", "-"]]
  end

  test "abre_tabuleiro" do
    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    tab = [["2", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_tabuleiro(tab,mines_board) == [["2", "2", "1"],
                                                          ["*", "*", "1"],
                                                          ["2", "2", "1"]]
  end

  test "generate_line_positions" do
    assert Minesweeper.generate_line_positions(0,3) == [{0,0},{0,1},{0,2}]
    assert Minesweeper.generate_line_positions(0,1) == [{0,0}]
    assert Minesweeper.generate_line_positions(2,3) == [{2,0},{2,1},{2,2}]
  end

  test "generate_tab_positions" do
    assert Minesweeper.generate_tab_positions(3,3) == [[{0,0},{0,1},{0,2}],
                                                  [{1,0},{1,1},{1,2}],
                                                  [{2,0},{2,1},{2,2}]]
  end

  test "abre_linha" do
    mines_board = [[false, false, false],
                    [true, true, false],
                    [false, false, false]]
    tab = [["2", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.abre_linha(tab,mines_board,[{0,0},{0,1},{0,2}]) == [["2", "2", "1"],
                                                                          ["-", "-","-"],
                                                                          ["-", "-","-"]]
    assert Minesweeper.abre_linha(tab,mines_board,[{1,0},{1,1},{1,2}]) == [["2", "-", "-"],
                                                                          ["*", "*","1"],
                                                                          ["-", "-","-"]]                                                                  
  end

  test "gera_lista" do
    assert Minesweeper.gera_lista(3,1) == [1,1,1]
    assert Minesweeper.gera_lista(1,"*") == ["*"]
  end

  test "gera_tabuleiro" do
    assert Minesweeper.gera_tabuleiro(3) == [["-", "-", "-"],
                                            ["-", "-", "-"],
                                            ["-", "-", "-"]]
    assert Minesweeper.gera_tabuleiro(1) == [["-"]]
  end

  test "gera_mapa_de_minas" do
    assert Minesweeper.gera_mapa_de_minas(3) == [[false, false, false],
                                                [false, false, false],
                                                [false, false, false]]
    assert Minesweeper.gera_mapa_de_minas(1) == [[false]]
  end

  test "conta_fechadas" do
    tab = [["2", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    assert Minesweeper.conta_fechadas(tab) == 8

    tab = [["2", "2", "2"],
          ["2", "2", "2"],
          ["2", "2", "2"]]
    assert Minesweeper.conta_fechadas(tab) == 0
  end

  test "conta_minas" do
    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    assert Minesweeper.conta_minas(mines_board) == 2

    mines_board = [[false, false, false],
                  [false, false, false],
                  [false, false, false]]
    assert Minesweeper.conta_minas(mines_board) == 0
  end

  test "end_game" do
    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    tab = [["2", "2", "1"],
          ["-", "-", "1"],
          ["2", "2", "1"]]

    assert Minesweeper.end_game(mines_board,tab) == true

    mines_board = [[false, false, false],
                  [true, true, false],
                  [false, false, false]]
    tab = [["2", "2", "1"],
          ["-", "-", "1"],
          ["2", "-", "1"]]

    assert Minesweeper.end_game(mines_board,tab) == false
  end

  test "get_header" do
    tab = [["2", "2", "1"],
          ["-", "-", "1"],
          ["2", "-", "1"]]
    assert Minesweeper.get_header(tab) == "     0 | 1 | 2\n______________\n"
  end

  test "get_line" do
    assert Minesweeper.get_line(["2", "2", "1"]) == "2 | 2 | 1\n"
  end

  test "get_all_lines" do
    tab = [["2", "2", "1"],
          ["-", "-", "1"],
          ["2", "-", "1"]]
    assert Minesweeper.get_all_lines(tab) == 
    "0  | 2 | 2 | 1\n1  | - | - | 1\n2  | 2 | - | 1\n"
  end

  test "gera_repeticao_char" do
    assert Minesweeper.gera_repeticao_char(5,"_") == "_____"
  end

  test "print_board_test" do
    tab = [["2", "2", "1"],
          ["-", "-", "1"],
          ["2", "-", "1"]]
    Minesweeper.test_print_board(tab)
  end

  test "abre_jogada" do
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    mines_board = [[false, false, false],
                  [false, true, false],
                  [false, false, false]]
    assert Minesweeper.abre_jogada({0,0},mines_board,tab) == [["1", "-", "-"],
                                                              ["-", "-", "-"],
                                                              ["-", "-", "-"]]
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    mines_board = [[false, false, false],
                  [false, true, false],
                  [false, false, false]]
    assert Minesweeper.abre_jogada({1,1},mines_board,tab) == [["-", "-", "-"],
                                                              ["-", "-", "-"],
                                                              ["-", "-", "-"]]
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "1", "-"]]
    mines_board = [[false, false, false],
                  [false, true, false],
                  [false, false, false]]
    assert Minesweeper.abre_jogada({2,1},mines_board,tab) == [["-", "-", "-"],
                                                              ["-", "-", "-"],
                                                              ["-", "1", "-"]] 
    tab = [["-", "-", "-"],
          ["-", "-", "-"],
          ["-", "-", "-"]]
    mines_board = [[true, false, false],
                  [false, false, false],
                  [false, false, false]]
    assert Minesweeper.abre_jogada({2,2},mines_board,tab) == [["-", "1", "0"],
                                                              ["1", "1", "0"],
                                                              ["1", "0", "0"]]                                                                                                                   
    end
end
