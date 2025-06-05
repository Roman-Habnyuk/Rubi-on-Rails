#!/usr/bin/env ruby
# Цей скрипт демонструє перевірку валідацій для моделей User, Post і Comment

require_relative 'config/environment'

puts "=== VALIDATION TESTING ==="
puts "\n"

# ==== USER VALIDATION ====
puts "USER VALIDATION"
puts "================"

puts "1. Створення коректного користувача:"
user = User.new(name: "Alice", email: "alice@example.com")
if user.save
  puts "✅ User created: #{user.inspect}"
else
  puts "❌ Errors: #{user.errors.full_messages.join(', ')}"
end

puts "\n2. Створення користувача без email:"
invalid_user = User.new(name: "Bob")
if invalid_user.save
  puts "❌ Should have failed but saved: #{invalid_user.inspect}"
else
  puts "✅ Correctly failed: #{invalid_user.errors.full_messages.join(', ')}"
end

# ==== POST VALIDATION ====
puts "\nPOST VALIDATION"
puts "================"

puts "3. Створення коректного поста:"
post = Post.new(title: "First Post", body: "This is a valid post body", user: user)
if post.save
  puts "✅ Post created: #{post.inspect}"
else
  puts "❌ Errors: #{post.errors.full_messages.join(', ')}"
end

puts "\n4. Створення поста без тіла:"
invalid_post = Post.new(title: "Untitled", body: "", user: user)
if invalid_post.save
  puts "❌ Should have failed but saved: #{invalid_post.inspect}"
else
  puts "✅ Correctly failed: #{invalid_post.errors.full_messages.join(', ')}"
end

# ==== COMMENT VALIDATION ====
puts "\nCOMMENT VALIDATION"
puts "==================="

puts "5. Створення валідного коментаря:"
comment = Comment.new(body: "Nice post!", user: user, post: post)
if comment.save
  puts "✅ Comment created: #{comment.inspect}"
else
  puts "❌ Errors: #{comment.errors.full_messages.join(', ')}"
end

puts "\n6. Створення коментаря без тексту:"
invalid_comment = Comment.new(body: "", user: user, post: post)
if invalid_comment.save
  puts "❌ Should have failed but saved: #{invalid_comment.inspect}"
else
  puts "✅ Correctly failed: #{invalid_comment.errors.full_messages.join(', ')}"
end

puts "\n=== TESTING COMPLETE ==="
