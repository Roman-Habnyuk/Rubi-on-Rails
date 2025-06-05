def create
  @user = User.new(user_params)
  if @user.save
    redirect_to @user, notice: 'Успішно створено!'
  else
    render :new, status: :unprocessable_entity
  end
end

def update
  if @user.update(user_params)
    redirect_to @user, notice: 'Успішно оновлено!'
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @user.destroy
  redirect_to users_path, notice: 'Успішно видалено!'
end
