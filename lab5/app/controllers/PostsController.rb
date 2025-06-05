def create
  @post = Post.new(post_params)
  if @post.save
    redirect_to @post, notice: 'Успішно створено!'
  else
    render :new, status: :unprocessable_entity
  end
end

def update
  if @post.update(post_params)
    redirect_to @post, notice: 'Успішно оновлено!'
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @post.destroy
  redirect_to posts_path, notice: 'Успішно видалено!'
end
