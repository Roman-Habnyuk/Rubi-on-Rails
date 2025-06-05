def create
  @comment = Comment.new(comment_params)
  if @comment.save
    redirect_to @comment, notice: 'Успішно створено!'
  else
    render :new, status: :unprocessable_entity
  end
end

def update
  if @comment.update(comment_params)
    redirect_to @comment, notice: 'Успішно оновлено!'
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @comment.destroy
  redirect_to comments_path, notice: 'Успішно видалено!'
end
