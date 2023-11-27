# frozen_string_literal: true

require './knight_board'
# Takes input from user
class KnightUI
  def initialize
    p 'Please input your starting square in the format [x, y] where x and y are numbers.'
    @startpoint = cleanup(gets.chomp)
    p 'Please input your end square in the format [x, y] where x and y are numbers.'
    @endpoint = cleanup(gets.chomp)
  end

  def cleanup(input)
    return input unless input.include?('[' && ']')

    cleaner = input[1...-1].split(',')
    cleaner.map(&:to_i)
  end

  def display_path
    board = Board.new
    knight = board.make_knight(@startpoint, @endpoint)
    p "Your path is #{knight.path.length - 1} moves long. Here's your path:"
    knight.path.reverse.each{ |coords| p coords }
  end
end

x = KnightUI.new
x.display_path
