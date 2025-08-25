# frozen_string_literal: true
class ChangeDefaultLevelInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:users, :level, 0)
  end
end
