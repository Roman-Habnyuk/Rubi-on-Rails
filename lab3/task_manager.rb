require 'json'
require 'yaml'
require_relative 'task'

class TaskManager
  def initialize
    @tasks = {}
  end

  def add_task(title, description, due_date)
    task = Task.new(title, description, due_date)
    @tasks[title.to_sym] = task
  end

  def edit_task(title, new_title: nil, new_description: nil, new_due_date: nil, new_completed: nil)
    return nil unless @tasks.key?(title.to_sym)

    task = @tasks[title.to_sym]

    if new_title && !new_title.empty? && new_title.to_sym != title.to_sym
      @tasks.delete(title.to_sym)
      task.title = new_title
      @tasks[new_title.to_sym] = task
    end

    task.description = new_description if new_description
    task.due_date = new_due_date if new_due_date
    task.completed = new_completed unless new_completed.nil?

    task
  end

  def delete_task(title)
    @tasks.delete(title.to_sym)
  end

  def search_tasks(keyword)
    @tasks.select { |_, task| task.matches?(keyword) }
  end

  def all_tasks
    @tasks
  end

  def save_to_json(filename)
    data = @tasks.transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(data))
  end

  def load_from_json(filename)
    return false unless File.exist?(filename)

    json_data = JSON.parse(File.read(filename), symbolize_names: true)
    @tasks = {}
    json_data.each do |title, data|
      @tasks[title] = Task.from_h(data)
    end
    true
  rescue JSON::ParserError
    false
  end

  def save_to_yaml(filename)
    data = @tasks.transform_values(&:to_h)
    File.write(filename, data.to_yaml)
  end

  def load_from_yaml(filename)
    return false unless File.exist?(filename)

    yaml_data = YAML.load_file(filename, symbolize_names: true)
    @tasks = {}
    yaml_data.each do |title, data|
      @tasks[title] = Task.from_h(data)
    end
    true
  rescue Psych::SyntaxError
    false
  end
end
