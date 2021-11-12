module MasterMind
    class Board
      attr_reader :is_breaker
      def initialize()
        @rows = Array.new()
        puts "welcome to mastermind, a two player game where one player makes a code and the other tries to break it.\n  The code consists of a four digit number, using only digits between 1 and 6.\n
        After every attempt, you'll get feedback in the form of keys:\n
        - O for every number you guessed in the wrong position\n
        - X for every number you guessed in the right position"
        puts "input 1 to play as the code maker, 2 to play as the code breaker"
        
        choice = gets.chomp
        until choice == "1" || choice == "2" do
          puts "Please input 1 to play as the code maker or 2 to play as the code breaker"
          choice = gets.chomp
        end
        
        if choice == "1"
          @maker = CodeMaker.new(true)
          @breaker = CodeBreaker.new(false)
          @is_breaker = false
          code = @maker.make_code
          @shieldedRow = ShieldedRow.new(code)
          @breaker.break_code(@shieldedRow,@rows)
        elsif choice == "2"
          @maker = CodeMaker.new(false)
          @breaker = CodeBreaker.new(true)
          @is_breaker = true
          code = @maker.make_code
          @shieldedRow = ShieldedRow.new(code)
          @breaker.break_code(@shieldedRow,@rows)
        end
        
      end
  
      def play(maker, breaker)
        
        puts "thanks for playing!"
  
      end
      
    end
  
    class Player
      attr_reader :is_player
        def initialize(bool)
          @is_player = bool
        end
          def valid?(str)
        
        if str.length == 4
          str = str.split("")
          for i in str
            if i.to_i > 6 || i.to_i < 1
              
              puts "You can only use numbers from 1 to 6 as your code."
              return false
              
            end
            true
          end
          
        else 
          puts "I need a 4 digits number..."
          false
        end
      end
      
    end
    
    class CodeMaker < Player
      
      def make_code
        
        if @is_player
          puts "You chose to be the CodeMaker, please input your code"
          code = gets.chomp
          until valid?(code) do
            puts "Please enter a valid code:"
            code = gets.chomp
          end
          
        else
          code = []
          for i in 0..3
            digit = (((rand*10).floor%6)+1).to_s
            code.push(digit)
          end
          code.join("")
        end
        code
      end
    end
  
    class CodeBreaker < Player
  
      def break_code(shielded_row,rows)
  
        if @is_player
          for i in 0..11
          puts "\n You have #{12-i} tries left to guess the code:\t"
            guess = gets.chomp
          until valid?(guess) do 
            puts "Please input a valid code:"
            guess = gets.chomp
          end
          puts take_guess(shielded_row,guess,rows)
          if guessed?(rows.last)
            puts "You cracked the code!"
            break
          end
          if i == 11
            puts "You're out of attempts, better luck next time!"
          end
        end
        else
          for i in 0..11
            puts "\n Computer has #{12-i} tries left"
            computer_guess(shielded_row,rows)
            if guessed?(rows.last)
              puts "The computer cracked the code!"
              break
            end
            if i == 11
              puts "The computer is out of attempts, You win!"
            end
          end
        end
      end
  
      def take_guess(shielded_row,str,rows)
          row = PeggedRow.new(str)
          code = shielded_row.holes
          rowholes = row.holes
          
          for i in 0..3
            if code[i] == rowholes[i]
              row.keys.push(KeyPeg.new("X"))
              
            elsif rowholes.include?(code[i])
              row.keys.push(KeyPeg.new("O"))
            end
          end
          
          rows.push(row)
          row.to_s
  
      end
  
      def computer_guess(shielded_row,rows)
        
        
        last_guess = rows.last.to_s
        
        guess = ""
        busy_spaces = 0
        if last_guess == ""
          if rows.last == nil
            guess = "1111"
          end
        else
          for i in 0..last_guess.length-1
            if last_guess[i] == "X"
              busy_spaces += 1
              
            elsif last_guess[i] == "O"
              busy_spaces += 1
              
            end
            
          end
          
          
        end
        unless rows.last == nil
          guess = rows.last.holes.join("")
          lastnum = rows.last.holes.last.to_i
          if lastnum < 6 || busy_spaces > 0
            for i in busy_spaces..3
              guess[i] = (lastnum+1).to_s
            end
          end
          
        end
        puts "computer input: #{guess}"
        take_guess(shielded_row,guess, rows)
  
      end
  
      def guessed?(row)
        row.to_s == "[ X X X X ]"
      end
  
    end
  
  
    class Row
      attr_reader :holes
      def initialize(str)
        @holes = Array.new(4)
        for i in 0..3
          @holes[i] = str[i]
        end
      end
  
  
    end
    
    class ShieldedRow < Row
    end
  
    class PeggedRow < Row
      attr_reader :keys
      def initialize(str)
        @keys = Array.new
        super
      end
      
      def set_keys(keys)
        for i in 0..3
          @keys[i] = str[i]
        end
      end
  
      def to_s
        str = "[ "
        for i in @keys
          str += i.color + " "
          
        end
        str += "]"
        str 
      end
  
    end
  
    class KeyPeg
      attr_reader :color
  
      def initialize(color)
        @color = color
      end
  
    end
  
    class Peg
      attr_reader :color
  
      def initialize(color)
        @color = color
      end
  
    end
  
  
  end
  
  include MasterMind
  
  game = Board.new()