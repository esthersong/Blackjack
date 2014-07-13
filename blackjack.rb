class String
	def black;          "\033[30m#{self}\033[0m" end
	def red;            "\033[31m#{self}\033[0m" end
	def green;          "\033[32m#{self}\033[0m" end
	def brown;          "\033[33m#{self}\033[0m" end
	def blue;           "\033[34m#{self}\033[0m" end
	def magenta;        "\033[35m#{self}\033[0m" end
	def cyan;           "\033[36m#{self}\033[0m" end
	def gray;           "\033[37m#{self}\033[0m" end
	def bg_black;       "\033[40m#{self}\033[0m" end
	def bg_red;         "\033[41m#{self}\033[0m" end
	def bg_green;       "\033[42m#{self}\033[0m" end
	def bg_brown;       "\033[43m#{self}\033[0m" end
	def bg_blue;        "\033[44m#{self}\033[0m" end
	def bg_magenta;     "\033[45m#{self}\033[0m" end
	def bg_cyan;        "\033[46m#{self}\033[0m" end
	def bg_gray;        "\033[47m#{self}\033[0m" end
	def bold;           "\033[1m#{self}\033[22m" end
	def reverse_color;  "\033[7m#{self}\033[27m" end
end
class Player
	$total_chips = 100
	cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'A', 'J', 'Q', 'K']
	$deck = []
	cards.each{|x| 
		for i in 0...4 
			$deck.push(x) 
		end
	}
	def initialize
		puts " "
		puts "-----------------------------------------------------------------------------".gray.bg_blue
		puts ""
		puts "                      *".bold.green + "Welcome to the game of Blackjack!" + "*".bold.green
		puts ""
		puts "How to play:".blue
		puts "There is one dealer and one player(you).Before dealing the cards, you"
		puts "you can bet as many chips as you have. But you must bet at least" + " 1 ".green.bold + "chip."
		puts "The dealer will then deal you two cards, and deal himself two cards."
		puts "You can then " + " hit ".bg_green+ " or " +" stay ".bg_green+". If you 'hit' you'll be dealt another card."
		puts "If you 'stay' you will not be dealt anymore cards. The objective"
		puts "objective is to reach" + " 21,".green.bold + " which is a " + "*Blackjack*".blue.bg_green + " or closest to 21 by"
		puts "adding the value of your cards. But be careful! A value greater than"
		puts "21 results in a " + "bust".red + " and you lose that hand immediately. The dealer"
		puts "will hit until his hand value is 17 or greater. Getting a blackjack wins"
		puts "you 3x what you bet and beating the dealer wins you 2x your bet amount."
		puts "Here are " + "100".green + " chips to start. You must bet at least 1 chip each round. Win"
		puts "as many chips as you can! The game is over when you run out of chips."
		puts "Good luck!"
		puts ""
		puts "To move on, press " + "[Enter]".bold.reverse_color
		enter = gets
		values
	end
	def values
		puts "All number cards equal the value of their number. (ex. 3 = 3)"
		puts "Face cards:".blue
		puts "J = 10"
		puts "Q = 10"
		puts "K = 10"
		puts "A = 1 or 11"
		puts ""
		puts "Ready to play? press " + "[Enter]".bold.reverse_color
		enter = gets
		start_game = NewGame.new
	end
	class NewGame
		@@total_chips = $total_chips
		def initialize
			@@deck = $deck
			@@shuffled_cards = @@deck.shuffle
			puts ""
			puts "                       *".green+"*".blue + " Let's Play Blackjack!" + " *".blue + "*".green
			puts ""
			bet
		end
		def bet
			puts "How many chips would you like to bet? type the number and press " + "[Enter]".bold.reverse_color
			puts "You currently have"+ " #{@@total_chips}".green + " chip(s)"
			@@bet_amount = gets.chomp
			@@bet_amount = @@bet_amount.to_i
			if @@bet_amount >= 1 && @@bet_amount <= @@total_chips
				@@total_chips -= @@bet_amount
				puts ""
				puts "You have " + "#{@@total_chips}".green + " chip(s) remaining"
				sleep 1
				puts "Dealer is dealing the cards...".gray
				puts ""
				sleep 1.5
				deal_cards
			elsif @@bet_amount < 1
				puts ""
				puts "ERROR: Must bet at least 1 chip!"
				puts ""
				bet
			elsif @@bet_amount > @@total_chips
				puts ""
				puts "You don't have enough chips!"
				puts ""
				bet
			end
		end
		def deal_cards
			@@hand = @@shuffled_cards.pop(2)
			@@dealer_hand = @@shuffled_cards.pop(2)
			@@hand_total_arr = []
			@@d_hand_total_arr = []
			@@hand.each{|x| 
				if x.is_a? String
					if x != "A"
						@@hand_total_arr.push(10)
					else 
						@@hand_total_arr.push(11)
					end
				else
					@@hand_total_arr.push(x)
				end
			}
			@@dealer_hand.each{|x| 
				if x.is_a? String
					if x != "A"
						@@d_hand_total_arr.push(10)
					else 
						@@d_hand_total_arr.push(11)
					end
				else
					@@d_hand_total_arr.push(x)
				end
			}
			show_hand
			hand_value
		end
		def show_hand
			puts "Your cards are: ".blue
			@@hand.each{|x| 
				if x.is_a? String
					print "[".red + x.red + "] ".red
					sleep 0.7
				elsif x.is_a? Integer
					print "[" + x.to_s + "] "
					sleep 0.7
				end
			}
			puts ""
		end
		def show_dealers_hand
				puts "Dealer's hand:".cyan
				@@dealer_hand.each{|x| 
				if x.is_a? String
					print "[".red + x.red + "] ".red
					sleep 0.5
				elsif x.is_a? Integer
					print "[" + x.to_s + "] "
					sleep 0.5
				end
			}
			puts ""
		end
		def hand_value 
			@@hand_total = @@hand_total_arr.inject{|sum, n| sum + n}
			aces = @@hand.count("A")
			@@hand_total_final = @@hand_total
			if aces > 0
				i = 0
				while i < aces do 
				 	if @@hand_total_final > 21
				 		@@hand_total_final -= 10
				 	end
				 	i += 1
				end
			end
			if @@hand_total_final > 21 
				bust
			elsif @@hand_total_final == 21
				blackjack
			else
				puts "Type "+ "hit".magenta + " and press " + "[Enter]".bold.reverse_color + " or type " + "stay".magenta + " and press " +"[Enter]".bold.reverse_color
				puts ""
				player_command = gets.chomp
				if player_command == 'hit'
					hit
				elsif player_command == 'stay'
					stay
				else
					hand_value
				end
			end
		end	
		def dealer_hand_value
			@@dealer_hand_total = @@d_hand_total_arr.inject{|sum, n| sum + n}
			d_aces = @@dealer_hand.count("A")
			@@d_hand_total_final = @@dealer_hand_total
			if d_aces > 0
				x = 0
				while x < d_aces do 
				 	if @@d_hand_total_final > 21
				 		@@d_hand_total_final -= 10
				 	end
				 	x += 1
				end
			end
			if @@d_hand_total_final < 17
				dealer_hit
			elsif @@d_hand_total_final >= 17 && @@d_hand_total_final < 21
				dealer_stay
			elsif @d_hand_total_final == 21
				dealer_blackjack
			else
				dealer_bust
			end
		end
		def hit
			@@new_card = @@shuffled_cards.pop(1)
			@@new_card = @@new_card[0]
			@@hand = @@hand.push(@@new_card)
			if @@new_card.is_a? String
				if @@new_card != "A"
					@@hand_total_arr.push(10)
				else 
					@@hand_total_arr.push(11)
				end
			else
				@@hand_total_arr.push(@@new_card)
			end
			show_hand
			hand_value
		end
		def dealer_hit
			d_new_card = @@shuffled_cards.pop(1)
			d_new_card = d_new_card[0]
			@@dealer_hand = @@dealer_hand.push(d_new_card)
			if d_new_card.is_a? String
				if d_new_card != "A"
					@@d_hand_total_arr.push(10)
				else 
					@@d_hand_total_arr.push(11)
				end
			else
				@@d_hand_total_arr.push(d_new_card)
			end
			puts ""
			puts "Dealer hits"
			show_dealers_hand
			dealer_hand_value
		end
		def stay
			show_dealers_hand
			dealer_hand_value
		end
		def dealer_stay
			puts ""
			puts "Dealer stays"
			if @@d_hand_total_final == @@hand_total_final
				draw
			elsif @@d_hand_total_final > @@hand_total_final
				dealer_win
			else
				player_win
			end
		end
		def bust
			puts ""
			puts "  BUST!  ".gray.bg_red + " Dealer wins!"
			puts "You lose #{@@bet_amount} chips.".red
			new_game
		end
		def blackjack
			puts ""
			puts "   BLACKJACK!!!   ".gray.bold.bg_green
			pool = @@bet_amount * 3
			@@total_chips += pool
			puts "You get #{pool} chips!".green
			new_game
		end
		def player_win
			puts "   *YOU WIN!*   ".gray.bg_green
			pool = @@bet_amount * 2
			puts "You get #{pool} chips!".green
			@@total_chips += @@bet_amount * 2
			new_game
		end
		def draw
			sleep 1
			puts ""
			puts "It's a draw!".magenta
			@@total_chips += @@bet_amount
			new_game  
		end
		def dealer_blackjack
			puts ""
			puts "Dealer got Blackjack!!!".bold.cyan
			puts "You lose #{@@bet_amount} chips.".red
			new_game
		end
		def dealer_win
			sleep 1
			puts ""
			puts "Dealer has the greater hand"
			puts " Dealer wins! ".gray.bg_red
			puts "You lose #{@@bet_amount} chips.".red
			new_game
		end
		def dealer_bust
			puts ""
			puts " Dealer bust! ".gray.bg_red
			puts ""
			player_win		
		end
		def new_game
			puts ""
			if @@total_chips > 0
				puts "Keep playing? type (Y/N) and press " + "[Enter]".bold.reverse_color
				puts ""
				play = gets.chomp
				if play.capitalize == "Y"
					new_round = NewGame.new
				elsif play.capitalize == "N"
					exit
				else
					new_game
				end
			elsif @@total_chips <= 0
				sleep 2	
				puts ""
				puts ""
				puts ""
				puts "*********************************GAME OVER********************************".gray.bg_red
				puts "          !!!!!You ran out of chips! Better luck next time!!!!!".red
				puts ""
				puts ""
				exit
			end
		end
		def exit
			puts ""
			puts "You ended the game with " +"#{@@total_chips}".green + " chips!"
			puts ""
		end
	end
end

new_game = Player.new
