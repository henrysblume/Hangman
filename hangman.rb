require "csv"
require "json"
words = CSV.open "5desk.csv"
@turn = 0
@new_word = nil
@guess_catalogue = []

class SaveFile
  def initialize(file)
    @file = file
  end

  def new_file(x, y, z)
    temp_hash = {
      "current_turn" => x,
      "guessed_letters" => y,
      "word" => z
    }
    File.open("./#{@file}.json", "w") do |f|
      f.write(temp_hash.to_json)
    end
  end

end

def random_word_creator
  lines = File.readlines "5desk.csv"
  word_list = []
  chosen_word = ""
  lines.each do |line|
    word_list << line.strip
    list_length = word_list.length
    random_number = rand(list_length)
    chosen_word = word_list[random_number]
  end
  chosen_word.split("")
end

def player_guess_getter
  print "\nGuess a letter:"
  player_guess = gets.chomp.downcase
  player_guess
end

def guess_storer
  while @turn < @new_word.length
    save()
    @guess_catalogue << player_guess_getter()
    print "You've guessed #{@guess_catalogue}!"
    print "\n"
    puts blank_mapper()
    @turn +=1
    end_condition_checker()
  end
end

def blank_mapper
  output = @new_word.map do |letter|
    if @guess_catalogue.include?(letter)
      " #{letter} "
    else
      " _ "
    end
  end
  output.join("")
end

def end_condition_checker
  is_victorious = @new_word.all? {|letter| @guess_catalogue.include?(letter)}
  if is_victorious
    puts "you win! ... Starting new game ... Generating new word."
    runner()
  elsif @turn == @new_word.length
    puts "you lose! ... Starting new game ... Generating new word."
    runner()
  end
end

def runner
  @turn = 0
  @guess_catalogue = []
  @new_word = random_word_creator()
  puts blank_mapper()
  guess_storer()
end

def start
  open()
end

def open
  puts "Would you like to resume a game?"
  user_answer = gets.chomp.downcase
  if user_answer == "yes"
    puts "Which file?"
    file_name = gets.chomp.downcase
    File.open("./#{file_name}.json", "r") do |f|
      data = f.read()
      new_hash = JSON.parse(data)
      @turn = new_hash["current_turn"]
      @guess_catalogue = new_hash["guessed_letters"]
      @new_word = new_hash["word"]
      guess_storer()
    end
  else
    runner()
  end
end

def save
  puts "Would you like to save your game?"
  user_answer = gets.chomp.downcase
  if user_answer == "yes"
    puts "Enter File Name:"
    file_name = gets.chomp.downcase
    new_save = SaveFile.new(file_name)
    new_save.new_file(@turn, @guess_catalogue, @new_word)
  end
end

start()
