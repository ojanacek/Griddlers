require './cell'

module Griddlers
  # Represents a game area
  class Grid
    CELL_SIZE = 20
    FONT_SIZE = 15
    attr_reader :cell_size, :offset, :columns, :rows
    attr_accessor :colour_empty, :colour_filled, :colour_space

    def initialize(columns, rows)
      @columns, @rows = columns, rows
      @grid, @col_labels, @row_labels = [], [], []
      rows.times { @grid << Array.new(columns) }
      # GUI
      @width, @height = columns * CELL_SIZE, rows * CELL_SIZE, CELL_SIZE
      @cell_size = CELL_SIZE
      @offset = [(768 - @width.to_i) / 2, (1000 - @height.to_i) / 2]
      @colour_empty, @colour_filled, @colour_space = '#FFF', '#000', '#FFEE00'
    end

    def [](*args)
      r, c = args
      args.length == 2 ? @grid[r][c] : @grid[r]
    end

    def []=(*args)
      r, c, v = args
      @grid[r][c] = v
    end

    # loops through all cells in the grid
    def each
      0.upto(rows - 1) do |r|
        0.upto(columns - 1) do |c|
          yield(self[r][c]) if block_given?
        end
      end
    end

    # returns true if all cells are coloured correctly
    def valid?
      each do |e|
        return false if !e.empty? && e.filled? && !e.should_be_filled?
      end
      true
    end

    # returns true if all cells are coloured
    def all_filled?
      each do |e|
        return false if e.empty?
      end
      true
    end

    # colours a cell on coordinates (c, r)
    # with a colour being 0 (space) or 1 (image)
    def colour!(r, c, colour)
      self[r][c].colour!(colour)
    end

    # colours a random cell with a correct colour
    def colour_random!
      loop do
        col, row = rand(columns), rand(rows)
        cell = self[row, col]
        if cell.empty?
          cell.should_be_filled? ? cell.colour!(1) : cell.colour!(0)
          break
        end
      end
    end

    # colours all cells with correct colours in order to reveal the image
    def reveal!
      each do |c|
        c.should_be_filled? ? c.colour!(1) : c.colour!(0)
      end
    end

    # removes a colour from a cell on coordinates (c, r)
    def erase!(r, c)
      self[r][c].erase!
    end

    # in order to be able to solve the puzzle,
    # labels around the grid are needed
    def init_labels
      counter = 0
      res = ''
      0.upto(rows - 1) do |r|
        0.upto(columns - 1) do |c|
          counter += 1 if self[r][c].should_be_filled?
          if !self[r][c].should_be_filled? || c == columns - 1
            if counter > 0
              res << counter.to_s + ' | '
              counter = 0
            end
          end
        end
        @row_labels[r] = res
        res = ''
      end

      counter = 0
      res = ''
      0.upto(columns - 1) do |c|
        0.upto(rows - 1) do |r|
          counter += 1 if self[r][c].should_be_filled?
          if !self[r][c].should_be_filled? || r == rows - 1
            if counter > 0
              res << counter.to_s + ' '
              counter = 0
            end
          end
        end
        @col_labels[c] = res
        res = ''
      end
    end

    # GUI methods

    # renders labels around the grid
    def render_labels(app)
      0.upto(rows - 1) do |r|
        app.para @row_labels[r], left: columns * cell_size + 5,
                                 top: r * cell_size - 3,
                                 font: FONT_SIZE.to_s + 'px', stroke: '#000'
      end

      render_column_labels(app)
    end

    # renders helpful lines in the grid
    def render_help_lines(app)
      app.strokewidth 3
      offset = 5 * cell_size
      (columns / 5 + 1).times do |o|
        app.line o * offset, 0, o * offset, rows * cell_size
      end
      (rows / 5 + 1).times do |o|
        app.line 0, o * offset, columns * cell_size, o * offset
      end
    end

    # renders the grid itself
    def render(app)
      0.upto(rows - 1) do |r|
        0.upto(columns - 1) do |c|
          render_cell(app, r, c)
        end
      end
    end

    private

    # returns a colour that should be used to colour
    # a cell on coordinates (c, r)
    def cell_colour(r, c)
      cell = self[r][c]
      return @colour_empty if cell.empty?
      return @colour_filled if cell.filled?
      @colour_space
    end

    # renders a cell on coordinates (c, r)
    def render_cell(app, r, c)
      app.stroke '#000'
      app.strokewidth 1
      app.fill cell_colour(r, c)
      app.rect c * cell_size, r * cell_size, cell_size, cell_size
    end

    # renders column labels
    def render_column_labels(app)
      0.upto(columns - 1) do |c|
        index = 0
        app.strokewidth 1
        @col_labels[c].each_line(' ') do |n|
          x = c * cell_size
          grid_height = rows * cell_size
          line_y_offset = (index + 1) * (FONT_SIZE + 6)
          text_y_offset = line_y_offset - FONT_SIZE - 7
          app.para n, left: x, top: grid_height + text_y_offset,
                      font: FONT_SIZE.to_s + 'px', stroke: '#000'

          app.line x, grid_height + line_y_offset,
                   x + FONT_SIZE, grid_height + line_y_offset
          index += 1
        end
      end
    end
  end
end
