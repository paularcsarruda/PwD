require 'json'
require 'securerandom'

PASSWORDS_FILE = 'passwords.json'

def display_menu
  puts("********* <<< PwD >>> *********")
  puts("+--- Your Password Manager ---+")
  puts("| [1] New Password            |")
  puts("| [2] Remove Password         |")
  puts("| [3] View Passwords          |")
  puts("| [4] Exit                    |")
  puts("+-----------------------------+")
end

def generate_password(length)
  charset = Array('0'..'9') + Array('a'..'z') + Array('A'..'Z') + ['!', '@', '#', '$', '%', '^', '&', '*', '+', '=', '<', '>', '?', '/', '~']
  password = Array.new(length) { charset.sample }.join
end

def load_passwords
  if File.exist?(PASSWORDS_FILE)
    json_data = File.read(PASSWORDS_FILE)
    JSON.parse(json_data, symbolize_names: true)
  else
    []
  end
rescue JSON::ParserError => e
  puts "Error parsing JSON: #{e.message}"
  []
end

def save_passwords(passwords)
  json_data = JSON.pretty_generate(passwords)
  File.write(PASSWORDS_FILE, json_data)
end

def add_pwd(passwords)
  puts("Enter the description: ")
  description = gets.chomp

  password = generate_password(13)

  password_entry = { description: description, password: password }
  passwords << password_entry

  save_passwords(passwords)  # Salva os passwords atualizados no arquivo
  puts("Password added successfully.")
end

def remove_pwd(passwords)
  if passwords.empty?
    puts("No passwords to remove.")
    return
  end

  puts("Current Passwords:")
  passwords.each_with_index do |password, idx|
    puts("#{idx + 1}. Description: #{password[:description]}, Password: #{password[:password]}")
  end

  puts("Enter the password index to remove (1 to #{passwords.length}): ")
  index = gets.chomp.to_i

  if index.between?(1, passwords.length)
    passwords.delete_at(index - 1)
    save_passwords(passwords)  # Salva os passwords atualizados no arquivo
    puts("Password removed successfully.")
  else
    puts("Invalid index. Please enter a valid index.")
  end
end

def view_pwd(passwords)
  if passwords.empty?
    puts("No passwords added yet.")
  else
    puts("List of Passwords:")
    passwords.each_with_index do |password, idx|
      puts("#{idx + 1}. Description: #{password[:description]}, Password: #{password[:password]}")
    end
  end
end

passwords = load_passwords

loop do
  display_menu
  puts("Enter your choice (1-4): ")
  choice = gets.chomp.to_i

  case choice
  when 1
    add_pwd(passwords)
  when 2
    remove_pwd(passwords)
  when 3
    view_pwd(passwords)
  when 4
    puts("Exiting PwD. Goodbye!")
    break
  else
    puts("Invalid choice. Please enter a number from 1 to 4.")
  end
end
