# Blog Platform Rails Application

This Rails application implements a simple blog platform with the following features:

- User registration and post creation
- Users can write posts and leave comments
- Comments are associated with both users and posts
- Data validations to ensure data integrity

## Models

### User
- **Attributes**: name, email
- **Validations**:
  - Name must be present
  - Email must be present and unique (case-insensitive)
- **Associations**: 
  - Has many Posts
  - Has many Comments

### Post
- **Attributes**: title, content, user_id
- **Validations**: 
  - Title must be present
  - Content must be present
- **Associations**: 
  - Belongs to a User
  - Has many Comments

### Comment
- **Attributes**: content, user_id, post_id
- **Validations**:
  - Content must be present
- **Associations**:
  - Belongs to a User
  - Belongs to a Post

## Database Schema

The database includes:
- `users` table to store user accounts
- `posts` table to store blog posts
- `comments` table to store user comments on posts

## Example Usage in Rails Console

You can test the models and validations using the Rails console:

```bash
rails console
```

Example operations:

```ruby
# Create a user
user = User.create(name: "Alice", email: "alice@example.com")

# Create a post
post = Post.create(title: "My First Post", content: "This is the content", user: user)

# Create a comment
comment = Comment.create(content: "Nice post!", user: user, post: post)

# Invalid post (missing title)
invalid_post = Post.create(content: "Missing title", user: user)
invalid_post.errors.full_messages
# => ["Title can't be blank"]

```

## Setup and Installation

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails db:seed` to load sample data
5. Start the server: `rails server
` 
6.Access the app at http://localhost:3000
