namespace :expense_manager do
  desc "Interactive test of Expense Manager models with validations"
  task interactive_test: :environment do
    puts "Welcome to the Expense Manager Interactive Test"
    puts "==============================================="

    # List existing data
    display_statistics

    loop do
      puts "\nSelect an action:"
      puts "1. Create a category"
      puts "2. Create a payment method"
      puts "3. Create an expense"
      puts "4. List all data"
      puts "5. Exit"
      print "> "
      
      choice = STDIN.gets.chomp.to_i
      
      case choice
      when 1
        create_category
      when 2
        create_payment_method
      when 3
        create_expense
      when 4
        display_statistics
      when 5
        puts "Goodbye!"
        break
      else
        puts "Invalid option. Please try again."
      end
    end
  end
  
  def display_statistics
    puts "\nCurrent Database Statistics:"
    puts "- Categories: #{Category.count}"
    puts "- Payment Methods: #{PaymentMethod.count}"
    puts "- Expenses: #{Expense.count}"
    
    puts "\nCategories:"
    Category.all.each { |c| puts "  - #{c.name}" }
    
    puts "\nPayment Methods:"
    PaymentMethod.all.each { |p| puts "  - #{p.name}" }
    
    puts "\nExpenses:"
    Expense.all.each do |e|
      puts "  - #{e.description}: $#{e.amount} (#{e.date})"
      puts "    Categories: #{e.categories.map(&:name).join(', ')}"
      puts "    Payment Methods: #{e.payment_methods.map(&:name).join(', ')}"
    end
  end
  
  def create_category
    puts "\nCreate a new Category"
    puts "--------------------"
    print "Enter category name: "
    name = STDIN.gets.chomp
    
    begin
      category = Category.create!(name: name)
      puts "✓ Category '#{category.name}' created successfully!"
    rescue => e
      puts "✗ Error creating category: #{e.message}"
    end
  end
  
  def create_payment_method
    puts "\nCreate a new Payment Method"
    puts "--------------------------"
    print "Enter payment method name: "
    name = STDIN.gets.chomp
    
    begin
      payment_method = PaymentMethod.create!(name: name)
      puts "✓ Payment Method '#{payment_method.name}' created successfully!"
    rescue => e
      puts "✗ Error creating payment method: #{e.message}"
    end
  end
  
  def create_expense
    puts "\nCreate a new Expense"
    puts "-------------------"
    print "Enter description: "
    description = STDIN.gets.chomp
    
    print "Enter amount: "
    amount = STDIN.gets.chomp.to_f
    
    print "Enter date (YYYY-MM-DD): "
    date_str = STDIN.gets.chomp
    date = Date.parse(date_str) rescue nil
    
    # Ask for categories
    puts "Available categories:"
    Category.all.each_with_index { |c, i| puts "  #{i+1}. #{c.name}" }
    print "Enter category numbers (comma-separated): "
    category_ids = STDIN.gets.chomp.split(',').map(&:strip).map(&:to_i)
    
    # Ask for payment methods
    puts "Available payment methods:"
    PaymentMethod.all.each_with_index { |p, i| puts "  #{i+1}. #{p.name}" }
    print "Enter payment method numbers (comma-separated): "
    payment_method_ids = STDIN.gets.chomp.split(',').map(&:strip).map(&:to_i)
    
    begin
      expense = Expense.new(
        description: description,
        amount: amount,
        date: date
      )
      
      # Add categories and payment methods
      category_ids.each do |id|
        if id > 0 && id <= Category.count
          expense.categories << Category.all[id-1]
        end
      end
      
      payment_method_ids.each do |id|
        if id > 0 && id <= PaymentMethod.count
          expense.payment_methods << PaymentMethod.all[id-1]
        end
      end
      
      expense.save!
      puts "✓ Expense '#{expense.description}' created successfully!"
    rescue => e
      puts "✗ Error creating expense: #{e.message}"
    end
  end
end 