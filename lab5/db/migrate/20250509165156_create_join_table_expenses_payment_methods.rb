class CreateJoinTableExpensesPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_join_table :expenses, :payment_methods do |t|
      # t.index [:expense_id, :payment_method_id]
      # t.index [:payment_method_id, :expense_id]
    end
  end
end
