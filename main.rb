DICTIONARY = File.readlines("5desk.txt")

MAX_WRONG_GUESSES = 6

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

#reads in player's guess
def get_player_guess
  print "Guess a letter: "
  guess = gets.chomp.upcase

  until guess.length == 1 and guess.upcase != guess.downcase
    puts "\nMust be a single letter"
    print "Guess a letter: "
    guess = gets.chomp.upcase
  end
  guess
end

#updates the player's guesses so far
def update_correct_guesses(answer, guess, current)
  answer.split("").each_with_index do |letter, index|
    if letter == guess
      current[index] = letter
    end
  end
  current
end

#main game loop
def play
  answer = generate_word
  correct_guesses = create_underscore_list(answer.length)
  wrong_guesses = []
  playing_game = true

  puts "ANSWER: #{answer}"

  while playing_game
    puts "\nWord: #{correct_guesses.join("")}"
    puts "Incorrect Guesses: #{wrong_guesses}"
    puts "Guesses remaining: #{MAX_WRONG_GUESSES - wrong_guesses.length}"

    guess = get_player_guess
    while correct_guesses.include? guess or wrong_guesses.include? guess
      puts "\nYou already guessed '#{guess}'."
      guess = get_player_guess
    end

    puts "\nYou guessed: #{guess}"

    if answer.include? guess
      puts "Correct"
      correct_guesses = update_correct_guesses(answer, guess, correct_guesses)
      if correct_guesses.join("") == answer
        puts "You Win! The answer was #{answer}"
        playing_game = false
      end
    else
      puts "Incorrect"
      wrong_guesses.push guess
      if wrong_guesses.length >= MAX_WRONG_GUESSES
        puts "You Lose. The answer was #{answer}."
        playing_game = false
      end
    end
  end
  puts "game over"
end

play
