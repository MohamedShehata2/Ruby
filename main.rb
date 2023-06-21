module Contactable
    attr_accessor :email, :phone
  
    def contact_details
      "#{email} | #{phone}"
    end
  end
  
  class Person
    attr_accessor :name
  
    def initialize(name)
      @name = name
    end
  
    def valid_name?
      name.match?(/\A[a-zA-Z]+\z/)
    end
  end
  
  class User < Person
    include Contactable
  
    def initialize(name, email, phone)
      super(name)
      @email = email
      @phone = phone
    end
  
    def self.valid_phone?(phone)
      phone.match?(/\A0\d{10}\z/)
    end
  
    def create
      if valid_name? && self.class.valid_phone?(phone)
        data = "#{name},#{email},#{phone}"
        File.open('users.txt', 'a') { |f| f.puts(data) }
        puts "-"*50
        puts "'#{name}' registered"
        puts "-"*50
      else
        raise "wrong cradintials"
      end
    rescue RuntimeError => e
      puts "-"*50
      puts "Error: #{e.message}"
      puts "-"*50
    end
  
    def self.list(n=0)
      users = File.readlines('users.txt').map do |line|
        name, email, phone = line.chomp.split(',')
        User.new(name,email,phone)
      end
  
      users = users.first(n) if n > 0
      users.each { |user| puts "#{user.name}: #{user.contact_details}" }
    end
  end
  
  class Menu
    def initialize
      @users_file = 'users.txt'
    end
  
    def run
      loop do
        puts "choose an option:"
        puts "1. Create new user"
        puts "2. List users"
        puts "3. Exit"
  
        choice = gets.chomp.to_i
  
        case choice
        when 1
          register_user
        when 2
          list_users
        when 3
          break
        else
          puts "Invalid Input"
        end
      end
    end
  
    private
  
    def register_user
      puts "Insert the user's name:"
      name = gets.chomp
  
      puts "Insert the user's email:"
      email = gets.chomp
  
      puts "Insert the user's phone number:"
      phone = gets.chomp
  
      user = User.new(name,email,phone)
      user.create
    end
  
    def list_users
      puts "Insert the number of users to list (0 for all):"
      n = gets.chomp.to_i
      puts "\n"
      puts "#"*50
      User.list(n)
      puts "\n"
      puts "#"*50
    end
  end
  
  Menu.new.run