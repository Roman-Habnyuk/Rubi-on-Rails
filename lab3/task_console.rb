require_relative 'task_manager'

class TaskConsole
  def initialize
    @manager = TaskManager.new
  end

  def run
    puts "Task Manager"
    puts "============"

    loop do
      show_menu
      handle_choice(gets.chomp.to_i)
    end
  end

  private

  def show_menu
    puts "\n1. Add Task"
    puts "2. Edit Task"
    puts "3. Delete Task"
    puts "4. Search Tasks"
    puts "5. Show All Tasks"
    puts "6. Save to JSON"
    puts "7. Save to YAML"
    puts "8. Load from File"
    puts "9. Exit"
    print "Choose an option: "
  end

  def handle_choice(choice)
    case choice
    when 1 then add_task
    when 2 then edit_task
    when 3 then delete_task
    when 4 then search_tasks
    when 5 then show_all_tasks
    when 6 then save_json
    when 7 then save_yaml
    when 8 then load_file
    when 9 then exit
    else puts "Invalid option"
    end
  end

  def add_task
    print "Title: "
    title = gets.chomp
    print "Description: "
    description = gets.chomp
    print "Due date (YYYY-MM-DD): "
    due_date = gets.chomp

    @manager.add_task(title, description, due_date)
    puts "Task added!"
  end

  def edit_task
    print "Title of task to edit: "
    title = gets.chomp

    unless @manager.all_tasks.key?(title.to_sym)
      puts "Task not found"
      return
    end

    print "New title (leave blank to keep): "
    new_title = gets.chomp

    print "New description (leave blank to keep): "
    new_description = gets.chomp

    print "New due date (leave blank to keep): "
    new_due_date = gets.chomp

    print "Completed? (yes/no/leave blank): "
    completed_input = gets.chomp.downcase
    new_completed = case completed_input
                    when 'yes' then true
                    when 'no' then false
                    else nil
                    end

    @manager.edit_task(
      title,
      new_title: new_title.empty? ? nil : new_title,
      new_description: new_description.empty? ? nil : new_description,
      new_due_date: new_due_date.empty? ? nil : new_due_date,
      new_completed: new_completed
    )
    puts "Task updated!"
  end

  def delete_task
    print "Title of task to delete: "
    title = gets.chomp
    if @manager.delete_task(title)
      puts "Task deleted!"
    else
      puts "Task not found"
    end
  end

  def search_tasks
    print "Keyword: "
    keyword = gets.chomp
    results = @manager.search_tasks(keyword)
    puts "Found #{results.size} task(s):"
    results.each_value { |task| puts task }
  end

  def show_all_tasks
    tasks = @manager.all_tasks
    puts "All Tasks:"
    tasks.each_value { |task| puts task }
  end

  def save_json
    print "Filename (without .json): "
    name = gets.chomp
    @manager.save_to_json("#{name}.json")
    puts "Saved to #{name}.json"
  end

  def save_yaml
    print "Filename (without .yml): "
    name = gets.chomp
    @manager.save_to_yaml("#{name}.yml")
    puts "Saved to #{name}.yml"
  end

  def load_file
    print "Filename (with extension): "
    name = gets.chomp

    if name.end_with?('.json')
      success = @manager.load_from_json(name)
    elsif name.end_with?('.yml')
      success = @manager.load_from_yaml(name)
    else
      puts "Unsupported file format"
      return
    end

    puts success ? "Loaded from #{name}" : "Failed to load file"
  end
end
