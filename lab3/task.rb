class Task
  attr_accessor :title, :description, :due_date, :completed

  def initialize(title, description, due_date, completed = false)
    @title = title
    @description = description
    @due_date = due_date
    @completed = completed
  end

  def to_h
    {
      title: @title,
      description: @description,
      due_date: @due_date,
      completed: @completed
    }
  end

  def self.from_h(hash)
    new(
      hash[:title],
      hash[:description],
      hash[:due_date],
      hash[:completed] || false
    )
  end

  def matches?(keyword)
    keyword = keyword.downcase
    @title.downcase.include?(keyword) || @description.downcase.include?(keyword)
  end

  def to_s
    "Title: #{@title}, Description: #{@description}, Due: #{@due_date}, Completed: #{@completed ? 'Yes' : 'No'}"
  end
end
