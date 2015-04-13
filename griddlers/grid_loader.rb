require './grid'

module Griddlers
  # It is responsible for loading a puzzle file and parsing to create a game
  class GridLoader
    class << self
      # returns true if the loaded file has a correct format
      def valid_file?(file)
        source = File.read(file)

        zeros = source.count('0')
        ones = source.count('1')
        line_breaks = source.count("\n")

        source.length == zeros + ones + line_breaks
      end

      # returns a new grid based on a file
      def load(file)
        return unless valid_file?(file)
        source = File.read(file)

        columns = source.index("\n")
        rows = source.lines.count
        grid = Grid.new(columns, rows)

        col, row = 0, 0
        source.each_char do |c|
          next if c == "\n"
          grid[row][col] = Cell.new(c == '1')
          col += 1
          row += 1 if col == columns
          col = 0 if col == columns
        end
        grid
      end
    end
  end
end
