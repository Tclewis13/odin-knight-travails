require 'rubocop'
require 'pry-byebug'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/traversal'
require 'rgl/dijkstra'
require_relative 'lib/space'

def get_legal_moves(origin)
  moves = []

  moves << [origin[0] - 1, origin[1] + 2] if origin[0] - 1 > 0 && origin[1] + 2 <= 7
  moves << [origin[0] - 2, origin[1] + 1] if origin[0] - 2 > 0 && origin[1] + 1 <= 7

  moves << [origin[0] + 1, origin[1] + 2] if origin[0] + 1 <= 7 && origin[1] + 2 <= 7
  moves << [origin[0] + 2, origin[1] + 1] if origin[0] + 2 <= 7 && origin[1] + 1 <= 7

  moves << [origin[0] - 2, origin[1] - 1] if origin[0] - 2 > 0 && origin[1] - 1 > 0
  moves << [origin[0] - 1, origin[1] - 2] if origin[0] - 1 > 0 && origin[1] - 2 > 0

  moves << [origin[0] + 1, origin[1] - 2] if origin[0] + 1 <= 7 && origin[1] - 2 > 0
  moves << [origin[0] + 2, origin[1] - 1] if origin[0] + 2 <= 7 && origin[1] - 1 > 0

  moves
end

def setup_spaces(board)
  count = 1
  board.each_with_index do |row, row_index|
    row.each_with_index do |column, column_index|
      board[row_index][column_index] = Space.new(row_index, column_index, count)
      count += 1
    end
  end
  board
end

def make_move_graph(board, graph)
  board.each_with_index do |row, row_index|
    row.each_with_index do |column, column_index|
      moves = get_legal_moves([row_index, column_index])
      moves.each do |move|
        graph.add_edge(board[row_index][column_index].graph_index, board[move[0]][move[1]].graph_index)
      end
    end
  end
end

def print_board(board)
  board.each do |row|
    puts ''
    row.each do |column|
      print "[#{column.graph_index}]"
    end
  end
end

def graph_to_board(board, graph_index)
  board.each do |row|
    row.each do |column|
      return [column.board_x, column.board_y] if column.graph_index == graph_index
    end
  end
end

def board_to_graph(board, x, y)
  board.each do |row|
    row.each do |column|
      return column.graph_index if column.board_x == x && column.board_y == y
    end
  end
end

def knight_moves(origin, target, board, graph)
  origin_graph_index = board_to_graph(board, origin[0], origin[1])
  target_graph_index = board_to_graph(board, target[0], target[1])
  graph_solution = graph.dijkstra_shortest_path(Hash.new(1), origin_graph_index, target_graph_index)
  graph_solution.each do |move|
    coordinate = graph_to_board(board, move)
    puts "[#{coordinate[0]} , #{coordinate[1]}]"
  end
end

board = Array.new(8) { Array.new(8) }
board = setup_spaces(board)
graph = RGL::AdjacencyGraph[]
make_move_graph(board, graph)
knight_moves([0, 0], [7, 7], board, graph)
