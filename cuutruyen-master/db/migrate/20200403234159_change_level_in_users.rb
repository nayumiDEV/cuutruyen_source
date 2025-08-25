# frozen_string_literal: true
class ChangeLevelInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:users, :level, false, 0)
  end
end
