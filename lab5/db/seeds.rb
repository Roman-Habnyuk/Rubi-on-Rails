# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Cleaning database..."
Expense.destroy_all
Category.destroy_all
PaymentMethod.destroy_all

# Create categories
puts "Creating categories..."
food = Category.create!(name: "Food")
transport = Category.create!(name: "Transport")
entertainment = Category.create!(name: "Entertainment")
utilities = Category.create!(name: "Utilities")

# Create payment methods
puts "Creating payment methods..."
cash = PaymentMethod.create!(name: "Cash")
credit_card = PaymentMethod.create!(name: "Credit Card")
debit_card = PaymentMethod.create!(name: "Debit Card")
bank_transfer = PaymentMethod.create!(name: "Bank Transfer")

# Create expenses
puts "Creating expenses..."
groceries = Expense.create!(
  description: "Groceries",
  amount: 75.50,
  date: Date.today - 2
)
groceries.categories << food
groceries.payment_methods << cash

rent = Expense.create!(
  description: "Monthly Rent",
  amount: 850.00,
  date: Date.today - 5
)
rent.categories << utilities
rent.payment_methods << bank_transfer

movie = Expense.create!(
  description: "Cinema",
  amount: 25.00,
  date: Date.today - 1
)
movie.categories << entertainment
movie.payment_methods << credit_card

# Test validations
puts "\nTesting validations..."

# Test invalid expense (negative amount)
begin
  invalid_expense = Expense.create!(
    description: "Invalid Expense",
    amount: -50.00,
    date: Date.today
  )
rescue => e
  puts "✓ Validation error as expected: #{e.message}"
end

# Test invalid expense (future date)
begin
  future_expense = Expense.create!(
    description: "Future Expense",
    amount: 100.00,
    date: Date.today + 10
  )
rescue => e
  puts "✓ Validation error as expected: #{e.message}"
end

# Test duplicate category
begin
  duplicate_category = Category.create!(name: "Food")
rescue => e
  puts "✓ Validation error as expected: #{e.message}"
end

puts "\nDatabase seeded successfully!"
puts "Created #{Category.count} categories"
puts "Created #{PaymentMethod.count} payment methods"
puts "Created #{Expense.count} expenses"
