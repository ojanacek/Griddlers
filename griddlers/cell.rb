# Represents a single field in a game grid
module Griddlers
  class Cell
    def initialize(filled)
      @value = -1
      @should_be_filled = filled
    end

    # returns true if the cell is not coloured at all
    def empty?
      @value == -1 # value -1 means a not coloured cell
    end

    # returns true if the cell is coloured as a part of the image
    def filled?
      @value == 1
    end

    # returns true if the cell should be coloured as a part of the image
    def should_be_filled?
      @should_be_filled == true
    end

    # colours the cell either as a part of the image or as a surrounding space
    # value 0 stands for a surrounding space
    # value 1 stands for a part of the image
    def colour!(value)
      @value = value
    end

    # removes a colour from the cell
    def erase!
      @value = -1
    end

    def to_s
      @value == 1 ? 'x' : ' '
    end
  end
end
