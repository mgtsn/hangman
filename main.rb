DICTIONARY = File.readlines("5desk.txt")
MAX_WRONG_GUESSES = 6
SAVE_DATA = "save/save.txt"

@answer
@correct_guesses
@wrong_guesses

#creates a list of underscores and spaces that will displays what the player has guessed
def create_underscore_list(i)
  a = []
  i.times do
    a.push "_ "
  end
  a
end

#picks a word between 5 and 12 letters
def generate_word
  word = DICTIONARY.sample.chomp
  word = DICTIONARY.sample.chomp until word.length >= 5 and word.length <= 12
  word.upcase
end

def load_game
  save_data = File.readlines(SAVE_DATA)
  @answer = save_data[0].chomp
  @correct_guesses = save_data[1].chomp.split("")
  @wrong_guesses = save_data[2].chomp.split("")
end

def save_game
  save_data = [@answer, @correct_guesses.join, @wrong_guesses.join]
  save_file = File.open(SAVE_DATA, "w")
  save_file.puts save_data
  puts "Game saved"
end

#reads in player's guess
def get_player_guess
  finished = false
  until finished
    print "Guess a letter: "
    guess = gets.chomp.upcase
    if guess == "SAVE"
      save_game
    elsif guess.length != 1 or guess.upcase == guess.downcase
      puts "\nMust be a single letter"
    elsif @correct_guesses.include? guess or @wrong_guesses.include? guess
      puts "\nYou already guessed '#{guess}'."
    else
      finished = true
    end
  end
  guess
end

def output_progress
  @answer.length.times do |i|
    if @correct_guesses.include? @answer[i]
      print @answer[i]
    else
      print "_ "
    end
  end
  print "\n"
end

def game_finshed?
  playing_game = true
  won = true
  @answer.each_char do |c|
    won = false unless @correct_guesses.include? c
  end
  if won
    puts "You Win! The answer was #{@answer}"
    playing_game = false
  elsif @wrong_guesses.length >= MAX_WRONG_GUESSES
    puts "You Lose. The answer was #{@answer}."
    playing_game = false
  end
  playing_game
end

def check_guess(guess)
  if @answer.include? guess
    puts "Correct"
    @correct_guesses.push guess
  else
    puts "Incorrect"
    @wrong_guesses.push guess
  end
end

def display_progress
  puts "\nWord: "
  output_progress
  puts "Incorrect Guesses: #{@wrong_guesses}"
  puts "Guesses remaining: #{MAX_WRONG_GUESSES - @wrong_guesses.length}"
end

#main game loop
def play
  @answer = generate_word
  @correct_guesses = []
  @wrong_guesses = []
  playing_game = true

  if File.exists?(SAVE_DATA)
    puts "There is a save file. Load game? [Y/N]"
    if ["Y", "YES"].include? gets.chomp.upcase
      load_game
    end
  end

  while playing_game
    display_progress

    guess = get_player_guess
    puts "\nYou guessed: #{guess}"

    check_guess(guess)
    playing_game = game_finshed?
  end
  puts "game over"
end

play
