require 'json'
require 'yaml'

# Додавання завдання
def add_task(tasks, title, categories, priority, due_date, completed = false)
  tasks[title.to_sym] = {
    categories: categories,
    priority: priority,
    due_date: due_date,
    completed: completed
  }
end

# Редагування завдання
def edit_task(tasks, title, new_categories: nil, new_priority: nil, new_due_date: nil, new_completed: nil)
  return unless tasks.key?(title.to_sym)

  task = tasks[title.to_sym]
  task[:categories] = new_categories unless new_categories.nil?
  task[:priority] = new_priority unless new_priority.nil?
  task[:due_date] = new_due_date unless new_due_date.nil?
  task[:completed] = new_completed unless new_completed.nil?
end

# Видалення завдання
def delete_task(tasks, title)
  tasks.delete(title.to_sym)
end

# Пошук завдань за ключовим словом
def search_tasks(tasks, keyword)
  tasks.select do |title, details|
    title.to_s.downcase.include?(keyword.downcase) ||
    details[:categories].any? { |cat| cat.downcase.include?(keyword.downcase) } ||
    details[:priority].downcase.include?(keyword.downcase)
  end
end

# Вивід усіх завдань
def output_tasks(tasks)
  tasks.each do |title, details|
    puts "\nЗавдання: #{title}"
    puts "Категорії: #{details[:categories].join(', ')}"
    puts "Пріоритет: #{details[:priority]}"
    puts "Термін: #{details[:due_date]}"
    puts "Виконано: #{details[:completed] ? 'Так' : 'Ні'}"
  end
end

# Збереження у файл
def save_to_json(tasks, filename)
  File.write(filename, JSON.pretty_generate(tasks))
end

def load_from_json(filename)
  JSON.parse(File.read(filename), symbolize_names: true) rescue {}
end

def save_to_yaml(tasks, filename)
  File.write(filename, tasks.to_yaml)
end

def load_from_yaml(filename)
  YAML.load_file(filename, symbolize_names: true) rescue {}
end

# Основна логіка
def main
  tasks = load_from_json("tasks.json")

  add_task(tasks, "Купити продукти", ["Покупки", "Особисті"], "Високий", "2024-02-28")
  add_task(tasks, "Завершити звіт", ["Робота", "Документи"], "Середній", "2024-03-01")

  edit_task(tasks, "Купити продукти", new_completed: true, new_categories: ["Покупки"])

  delete_task(tasks, "Завершити звіт")

  add_task(tasks, "Прочитати книгу", ["Особисті", "Саморозвиток"], "Низький", "2024-04-15")

  puts "\n🔍 Результати пошуку за 'особисті':"
  puts search_tasks(tasks, "особисті")

  puts "\n📋 Поточний список завдань:"
  output_tasks(tasks)

  save_to_json(tasks, "tasks.json")
  save_to_yaml(tasks, "tasks.yaml")
end

main if __FILE__ == $0
