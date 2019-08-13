#!/usr/bin/env ruby

# How to run:
# ruby roulette.rb <number of rounds to play>

# ruby roulette.rb 40
# Notes: It takes around 50 seconds to complete one full round of roulette.

# Created by: Techryptic

require 'colorize'

def main()
    @bankroll ||= 500
    @bet ||= 2
    @status ||= 1
    @round ||= 1
    for arg in ARGV
       numofrounds = Integer(arg)
       numofrounds = numofrounds + 1
    end
    if @round == numofrounds
        exit!
    end
    puts "\n"
    puts "Welcome to Ant's Roulette - Current Round: #{@round}"
    puts  "Current bankroll: $#{@bankroll}"
    pick()
end

def pick()
    @pick = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37].sample
    #added 37th number to represent double-zero 00.
    puts "Wheel spin landed on: #{@pick}"
    deposit()
end

def deposit()
    puts "Current Bet Amount: $#{@bet}"
    if (1..24).member?(@pick)
        total = @bet*2
        puts "WON".green+" $#{total}"
        @bankroll = @bankroll + @bet
        puts "Balance: $#{@bankroll}"
        @status = 1
        #puts "Status: #{@status}"
        @bet = 2
        @status = 1
        @round = @round + 1
        main()
    else
        total = @bet*2
        puts "LOST".red+" $#{total}"
        @round = @round + 1
        case @status
            when 1 #Lost $4
                @bet = 4
                @bankroll = @bankroll - 4
                puts "Balance: $#{@bankroll}"

                @status = 8
                #puts "Status: #{@status}"
                main()
            when 8 #Lost $8 -- $12 total
                @bet = 12
                @bankroll = @bankroll - 8 #12
                puts "Balance: $#{@bankroll}"

                @status = 24
                #puts "Status: #{@status}"
                main()
            when 24 #Lost $24 -- $36 total
                @bet = 36
                @bankroll = @bankroll - 24 #36
                puts "Balance: $#{@bankroll}"

                @status = 72
                #puts "Status: #{@status}"
                main()
            when 72 #Lost
                @bet = 108
                @bankroll = @bankroll - 72
                puts "Balance: $#{@bankroll}"

                @status = 216
                #puts "Status: #{@status}"
                main()
            when 216
                @bet = 324
                @bankroll = @bankroll - 216
                puts "Balance: $#{@bankroll}"

                @status = 324
                #puts "Status: #{@status}"
                main()
            when 324
                @bankroll = @bankroll - 648
                puts "Balance: $#{@bankroll}"

                puts "\n"
                puts "7 Straight loses. Give up!".yellow
                exit!
        end
    end
end
main()
