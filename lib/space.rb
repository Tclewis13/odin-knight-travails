class Space
  attr_accessor :board_x, :board_y, :graph_index

  def initialize(board_x, board_y, graph_index)
    self.board_x = board_x
    self.board_y = board_y
    self.graph_index = graph_index
  end
end
