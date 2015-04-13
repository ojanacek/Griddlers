require './grid_loader'
require './grid'

module Griddlers
  Shoes.app width: 768, height: 1000, title: 'Griddlers' do

    # adjusts a windows size based on the game area size
    def adjust_window
    #  don't know how
    end

    # renders the game area
    def render_field
      clear do
        flow margin: 8 do
          button('Load game') do
            file = ask_open_file
            new_game file unless file.nil?
          end
          button('Space colour', displace_left: 100) do
            @field.colour_space = change_colour
            render_field
          end
          button('Fill colour', displace_left: 100) do
            @field.colour_filled = change_colour
            render_field
          end
          button('Help', displace_left: 200) do
            next if @finished
            @field.colour_random!
            @finished = true if @field.all_filled?
            render_field
          end
          button('Reveal', displace_left: 200) do
            next if @finished
            @field.reveal!
            @finished = true
            render_field
          end
        end

        @field.render self
        @field.render_labels self
        @field.render_help_lines self
      end
    end

    # starts a new game
    def new_game(level)
      unless Griddlers::GridLoader.valid_file? level
        alert('Opened file has an invalid format.')
        return
      end
      @field = Griddlers::GridLoader.load level
      @field.init_labels
      translate -@old_offset.first, -@old_offset.last unless @old_offset.nil?
      translate @field.offset.first, @field.offset.last
      @old_offset = @field.offset
      @finished = false
      adjust_window
      render_field
    end

    new_game './games/small'

    click do |button, x, y|
      next if @finished
      fx = ((x - @field.offset.first) / @field.cell_size).to_i
      fy = ((y - @field.offset.last) / @field.cell_size).to_i
      # checks if clicked outside the grid
      next if fy < 0 || fy > @field.rows || fx < 0 || fx > @field.columns
      @field.colour!(fy, fx, 1) if button == 1
      @field.colour!(fy, fx, 0) if button == 2
      @field.erase!(fy, fx) if button == 3
      render_field

      if @field.all_filled?
        @finished = @field.valid?
        alert('Congratulations!') if @finished
        alert('Some cells are not filled correctly.') unless @finished
      end
    end

    # returns a colour from a colour-picker
    def change_colour
      new_colour = ask_color('Pick a new colour')
      rgb_to_hex new_colour
    end

    # converts a Shoes::Color to the colour hex representation
    def rgb_to_hex(rgb_colour)
      res = '#'
      res << sprintf('%02X', rgb_colour.red)
      res << sprintf('%02X', rgb_colour.green)
      res << sprintf('%02X', rgb_colour.blue)
      res
    end
  end
end
