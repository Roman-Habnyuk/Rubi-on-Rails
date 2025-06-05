require 'json'
require 'yaml'

# Структура джерела інформації:
# :name => {
#   :alphabet => ['A', 'B', 'C'],
#   :probabilities => { 'A' => 0.5, 'B' => 0.3, 'C' => 0.2 },
#   :type => 'memoryless' або 'first-order'
# }

$sources = {}

def add_source
  print "Назва джерела: "
  name = gets.chomp.to_sym

  print "Введіть алфавіт (символи через кому): "
  alphabet = gets.chomp.split(',').map(&:strip)

  puts "Введіть ймовірності для кожного символу (у форматі A:0.5,B:0.3,C:0.2):"
  raw_probs = gets.chomp
  probabilities = raw_probs.split(',').map { |pair| pair.strip.split(':') }.to_h
  probabilities.transform_values!(&:to_f)

  print "Тип джерела (memoryless або first-order): "
  type = gets.chomp.strip.downcase

  $sources[name] = {
    alphabet: alphabet,
    probabilities: probabilities,
    type: type
  }
end

def edit_source
  print "Введіть назву джерела для редагування: "
  name = gets.chomp.to_sym

  unless $sources.key?(name)
    puts "Джерело не знайдено"
    return
  end

  print "Нова назва (або Enter, щоб не змінювати): "
  new_name = gets.chomp
  if !new_name.empty? && new_name.to_sym != name
    $sources[new_name.to_sym] = $sources.delete(name)
    name = new_name.to_sym
  end

  print "Новий алфавіт (або Enter): "
  new_alphabet = gets.chomp
  $sources[name][:alphabet] = new_alphabet.split(',').map(&:strip) unless new_alphabet.empty?

  print "Нові ймовірності (формат A:0.5,B:0.5 або Enter): "
  new_probs = gets.chomp
  unless new_probs.empty?
    probabilities = new_probs.split(',').map { |pair| pair.strip.split(':') }.to_h
    probabilities.transform_values!(&:to_f)
    $sources[name][:probabilities] = probabilities
  end

  print "Новий тип (memoryless/first-order або Enter): "
  new_type = gets.chomp.strip.downcase
  $sources[name][:type] = new_type unless new_type.empty?
end

def delete_source
  print "Введіть назву джерела для видалення: "
  name = gets.chomp.to_sym
  $sources.delete(name) || puts("Джерело не знайдено")
end

def search_source
  print "Пошуковий запит (частина назви або символ алфавіту): "
  query = gets.chomp.downcase

  results = $sources.select do |name, data|
    name.to_s.downcase.include?(query) ||
      data[:alphabet].any? { |sym| sym.downcase.include?(query) }
  end

  puts "Знайдено #{results.size} джерел:"
  output_sources(results)
end

def output_sources(collection)
  if collection.empty?
    puts "Немає джерел для відображення"
    return
  end

  collection.each do |name, data|
    puts "\nНазва: #{name}"
    puts "Алфавіт: #{data[:alphabet].join(', ')}"
    puts "Ймовірності:"
    data[:probabilities].each { |k, v| puts "  #{k}: #{v}" }
    puts "Тип: #{data[:type]}"
  end
end

def show_all
  output_sources($sources)
end

def save_to_file(format)
  print "Назва файлу для збереження (без розширення): "
  filename = gets.chomp

  case format
  when :json
    File.write("#{filename}.json", JSON.pretty_generate($sources))
    puts "Збережено у #{filename}.json"
  when :yaml
    File.write("#{filename}.yml", $sources.to_yaml)
    puts "Збережено у #{filename}.yml"
  end
end

def load_from_file
  print "Введіть шлях до файлу (з розширенням .json або .yml): "
  filename = gets.chomp

  if File.exist?(filename)
    if filename.end_with?('.json')
      $sources = JSON.parse(File.read(filename), symbolize_names: true)
    elsif filename.end_with?('.yml')
      $sources = YAML.load_file(filename, symbolize_names: true)
    else
      puts "Непідтримуваний формат файлу."
    end
    puts "Завантажено з #{filename}"
  else
    puts "Файл не знайдено: #{filename}"
  end
end

# Головне меню
puts "Менеджер джерел інформації"
puts "=========================="

loop do
  puts "\n1. Додати джерело"
  puts "2. Редагувати джерело"
  puts "3. Видалити джерело"
  puts "4. Пошук джерела"
  puts "5. Зберегти в JSON"
  puts "6. Зберегти в YAML"
  puts "7. Завантажити з файлу"
  puts "8. Показати всі джерела"
  puts "9. Вийти"
  print "Оберіть опцію: "

  case gets.to_i
  when 1 then add_source
  when 2 then edit_source
  when 3 then delete_source
  when 4 then search_source
  when 5 then save_to_file(:json)
  when 6 then save_to_file(:yaml)
  when 7 then load_from_file
  when 8 then show_all
  when 9 then break
  else puts "Невірний вибір"
  end
end
