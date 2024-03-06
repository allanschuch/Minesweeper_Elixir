defmodule Minesweeper do
  # PRIMEIRA PARTE - FUNÇÕES PARA MANIPULAR OS TABULEIROS DO JOGO (MATRIZES)

  # A ideia das próximas funções é permitir que a gente acesse uma lista usando um indice,
  # como se fosse um vetor

  # get_arr/2 (get array):  recebe uma lista (vetor) e uma posicao (p) e devolve o elemento
  # na posição p do vetor. O vetor começa na posição 0 (zero). Não é necessário tratar erros.

  def get_arr([], _posicao), do: nil

  def get_arr([h|_t], 0), do: h 

  def get_arr([_h|t], posicao), do: get_arr(t,posicao-1) 

  # update_arr/3 (update array): recebe uma lista(vetor), uma posição (p) e um novo valor (v)e devolve um
  # novo vetor com o valor v na posição p. O vetor começa na posição 0 (zero)

  def update_arr([_h|t],0,valor), do: [valor|t]

  def update_arr([h|t],posicao,valor), do: [h|update_arr(t,posicao-1,valor)]

  # O tabuleiro do jogo é representado como uma matriz. Uma matriz, nada mais é do que um vetor de vetores.
  # Dessa forma, usando as operações anteriores, podemos criar funções para acessar os tabuleiros, como
  # se  fossem matrizes:

  # get_pos/3 (get position): recebe um tabuleiro (matriz), uma linha (l) e uma coluna (c) (não precisa validar).
  # Devolve o elemento na posicao tabuleiro[l,c]. Usar get_arr/2 na implementação

  def get_pos([h|_t],{0,coluna}), do: get_arr(h,coluna)

  def get_pos([_h|t],{linha,coluna}), do: get_pos(t,{linha-1,coluna})  

  # update_pos/4 (update position): recebe um tabuleiro, uma linha, uma coluna e um novo valor. Devolve
  # o tabuleiro modificado com o novo valor na posiçao linha x coluna. Usar update_arr/3 e get_arr/2 na implementação

  def update_pos([h|t],{0,coluna},valor), do: [update_arr(h,coluna,valor)|t]

  def update_pos([h|t],{linha,coluna},valor), do: [h|update_pos(t,{linha-1,coluna},valor)]

  # SEGUNDA PARTE: LÓGICA DO JOGO

  #-- is_mine/3: recebe um tabuleiro com o mapeamento das minas, uma linha, uma coluna. Devolve true caso a posição contenha
  # uma mina e false caso contrário. Usar get_pos/3 na implementação
  #
  # Exemplo de tabuleiro de minas:
  #
  # _mines_board = [[false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, true , false, false, false, false],
  #                 [false, false, false, false, false, true, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false]]
  #
  # esse tabuleiro possuí minas nas posições 4x4 e 5x5

  def is_mine(tab,{l,c}), do: get_pos(tab,{l,c})

  # is_valid_pos/3 recebe o tamanho do tabuleiro (ex, em um tabuleiro 9x9, o tamanho é 9),
  # uma linha e uma coluna, e diz se essa posição é válida no tabuleiro. Por exemplo, em um tabuleiro
  # de tamanho 9, as posições 1x3,0x8 e 8x8 são exemplos de posições válidas. Exemplos de posições
  # inválidas seriam 9x0, 10x10 e -1x8

  def is_valid_pos(tamanho,{l,c}), do: l < tamanho && l >= 0 && c < tamanho && c >= 0

  # valid_moves/3: Dado o tamanho do tabuleiro e uma posição atual (linha e coluna), retorna uma lista
  # com todas as posições adjacentes à posição atual
  # Exemplo: Dada a posição linha 3, coluna 3, as posições adjacentes são: [{2,2},{2,3},{2,4},{3,2},{3,4},{4,2},{4,3},{4,4}]
  #   ...   ...      ...    ...   ...
  #   ...  (2,2)    (2,3)  (2,4)  ...
  #   ...  (3,2)    (3,3)  (3,4)  ...
  #   ...  (4,2)    (4,3)  (4,4)  ...
  #   ...   ...      ...    ...   ...

  #  Dada a posição (0,0) que é um canto, as posições adjacentes são: [(0,1),(1,0),(1,1)]

  #  (0,0)  (0,1) ...
  #  (1,0)  (1,1) ...
  #   ...    ...  ..
  # Uma maneira de resolver seria gerar todas as 8 posições adjacentes e depois filtrar as válidas usando is_valid_pos

  def valid_moves(tam,position) do 
    get_adj(position) 
    |> Enum.filter(fn(x) -> 
      is_valid_pos(tam,x)
    end)
  end

  def get_adj({l,c}), do: [{l,c-1},{l,c+1},{l-1,c-1},{l-1,c},{l-1,c+1},{l+1,c-1},{l+1,c},{l+1,c+1}]

  #def get_first({first,_second}), do: first

  #def get_second({_first,second}), do: second

  # conta_minas_adj/3: recebe um tabuleiro com o mapeamento das minas e uma  uma posicao  (linha e coluna), e conta quantas minas
  # existem nas posições adjacentes

  def conta_minas_adj(tab,position) do
    get_adj(position) 
    |> Enum.filter(fn(x) -> 
      is_valid_pos(get_tam(tab),x)
      && is_mine(tab,x)
    end)
    |> Enum.map(fn _x -> 1 end)
    |> Enum.reduce(0,&(&1+&2))
  end

  def get_tam([_h|[]]), do: 1

  def get_tam([_h|t]), do: 1 + get_tam(t)

  # abre_jogada/4: é a função principal do jogo!!
  # recebe uma posição a ser aberta (linha e coluna), o mapa de minas e o tabuleiro do jogo. Devolve como
  # resposta o tabuleiro do jogo modificado com essa jogada.
  # Essa função é recursiva, pois no caso da entrada ser uma posição sem minas adjacentes, o algoritmo deve
  # seguir abrindo todas as posições adjacentes até que se encontre posições adjacentes à minas.
  # Vamos analisar os casos:
  # - Se a posição a ser aberta é uma mina, o tabuleiro não é modificado e encerra
  # - Se a posição a ser aberta já foi aberta, o tabuleiro não é modificado e encerra
  # - Se a posição a ser aberta é adjacente a uma ou mais minas, devolver o tabuleiro modificado com o número de
  # minas adjacentes na posição aberta
  # - Se a posição a ser aberta não possui minas adjacentes, abrimos ela com zero (0) e recursivamente abrimos
  # as outras posições adjacentes a ela

  #def abre_jogada(l,c,minas,tab) do
  #   (...)
  #end

# abre_posicao/4, que recebe um tabuleiro de jogos, o mapa de minas, uma linha e uma coluna
# Essa função verifica:
# - Se a posição {l,c} já está aberta (contém um número), então essa posição não deve ser modificada
# - Se a posição {l,c} contém uma mina no mapa de minas, então marcar  com "*" no tabuleiro
# - Se a posição {l,c} está fechada (contém "-"), escrever o número de minas adjascentes a essa posição no tabuleiro (usar conta_minas)

def abre_posicao(tab,mines_board,position) do
  cond do
    is_mine(mines_board,position) ->
      update_pos(
        tab,
        position,
        "*"
      )
    get_pos(tab,position) == "-" ->
      update_pos(
        tab,
        position,
        conta_minas_adj(mines_board,position)
        |> Integer.to_string
      )
    true -> tab
  end
end

# abre_tabuleiro/2: recebe o mapa de Minas e o tabuleiro do jogo, e abre todo o tabuleiro do jogo, mostrando
# onde estão as minas e os números nas posições adjecentes às minas.Essa função é usada para mostrar
# todo o tabuleiro no caso de vitória ou derrota. Para implementar esta função, usar a função abre_posicao/4


  def abre_tabuleiro(tab,mines_board) do
    tamanho = get_tam(tab)
    abre_tabuleiro_aux(
      tab,
      mines_board,
      generate_tab_positions(tamanho,tamanho)
    )
  end

  defp abre_tabuleiro_aux(tab,mines_board,[linha|[]]), do: abre_linha(tab,mines_board,linha)

  defp abre_tabuleiro_aux(tab,mines_board,[linha|t]) do
    abre_linha(
      abre_tabuleiro_aux(tab,mines_board,t),
      mines_board,
      linha
    )
  end

  def abre_linha(tab,mines_board,[posicao|[]]), do: abre_posicao(tab,mines_board,posicao)

  def abre_linha(tab,mines_board,[posicao|t]) do
    abre_posicao(
      abre_linha(tab,mines_board,t),
      mines_board,
      posicao
    )
  end 

  def generate_tab_positions(1,tamanho_c), do: [generate_line_positions(0,tamanho_c)]

  def generate_tab_positions(tamanho_l,tamanho_c) do 
    generate_tab_positions(tamanho_l-1,tamanho_c) ++ [generate_line_positions(tamanho_l-1,tamanho_c)]
  end
  
  def generate_line_positions(index,1), do: [{index,0}]

  def generate_line_positions(index,tamanho), do: generate_line_positions(index,tamanho-1) ++ [{index,tamanho-1}]

# board_to_string/1: -- Recebe o tabuleiro do jogo e devolve uma string que é a representação visual desse tabuleiro.
# Essa função é aplicada no tabuleiro antes de fazer o print dele na tela. Usar a sua imaginação para fazer um
# tabuleiro legal. Olhar os exemplos no .pdf com a especificação do trabalho. Não esquecer de usar \n para quebra de linhas.
# Você pode quebrar essa função em mais de uma: print_header, print_linhas, etc...

  #def board_to_string(tab) do
  # (...)
  #end

# gera_lista/2: recebe um inteiro n, um valor v, e gera uma lista contendo n vezes o valor v

  #def gera_lista(0,v), do: ...
  #def gera_lista(n,v), do: ...

# -- gera_tabuleiro/1: recebe o tamanho do tabuleiro de jogo e gera um tabuleiro  novo, todo fechado (todas as posições
# contém "-"). Usar gera_lista

  #def gera_tabuleiro(n), do: ...

# -- gera_mapa_de_minas/1: recebe o tamanho do tabuleiro e gera um mapa de minas zero, onde todas as posições contém false

  #def gera_mapa_de_minas(n), do: ...


# conta_fechadas/1: recebe um tabueleiro de jogo e conta quantas posições fechadas existem no tabuleiro (posições com "-")

  #def conta_fechadas(tab) do
  # (...)
  #end

# -- conta_minas/1: Recebe o tabuleiro de Minas (MBoard) e conta quantas minas existem no jogo

  #def conta_minas(minas) do
  # (...)
  #end

# end_game?/2: recebe o tabuleiro de minas, o tauleiro do jogo, e diz se o jogo acabou.
# O jogo acabou quando o número de casas fechadas é igual ao numero de minas
  #def end_game(minas,tab), do:  ...

#### fim do módulo
end

###################################################################
###################################################################

# A seguir está o motor do jogo!
# Somente descomentar essas linhas quando as funções do módulo anterior estiverem
# todas implementadas

defmodule Motor do
#  def main() do
#   v = IO.gets("Digite o tamanho do tabuleiro: \n")
#   {size,_} = Integer.parse(v)
#   minas = gen_mines_board(size)
#   IO.inspect minas
#   tabuleiro = Minesweeper.gera_tabuleiro(size)
#   game_loop(minas,tabuleiro)
#  end
#  def game_loop(minas,tabuleiro) do
#    IO.puts Minesweeper.board_to_string(tabuleiro)
#    v = IO.gets("Digite uma linha: \n")
#    {linha,_} = Integer.parse(v)
#    v = IO.gets("Digite uma coluna: \n")
#    {coluna,_} = Integer.parse(v)
#    if (Minesweeper.is_mine(minas,linha,coluna)) do
#      IO.puts "VOCÊ PERDEU!!!!!!!!!!!!!!!!"
#      IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,tabuleiro))
#      IO.puts "TENTE NOVAMENTE!!!!!!!!!!!!"
#    else
#      novo_tabuleiro = Minesweeper.abre_jogada(linha,coluna,minas,tabuleiro)
#      if (Minesweeper.end_game(minas,novo_tabuleiro)) do
#          IO.puts "VOCÊ VENCEU!!!!!!!!!!!!!!"
#          IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,novo_tabuleiro))
#          IO.puts "PARABÉNS!!!!!!!!!!!!!!!!!"
#      else
#          game_loop(minas,novo_tabuleiro)
#      end
#    end
#  end
#  def gen_mines_board(size) do
#    add_mines(ceil(size*size*0.15), size, Minesweeper.gera_mapa_de_minas(size))
#  end
#  def add_mines(0,_size,mines), do: mines
#  def add_mines(n,size,mines) do
#    linha = :rand.uniform(size-1)
#    coluna = :rand.uniform(size-1)
#    if Minesweeper.is_mine(mines,linha,coluna) do
#      add_mines(n,size,mines)
#    else
#      add_mines(n-1,size,Minesweeper.update_pos(mines,linha,coluna,true))
#    end
#  end
end

#Motor.main()
