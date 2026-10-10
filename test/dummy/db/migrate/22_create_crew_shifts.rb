# frozen_string_literal: true

class CreateCrewShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :crew_shifts do |t|
      t.references :crew_member, null: false, foreign_key: true
      t.string :name
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end

    create_table :crew_shift_tags, id: :bigint do |t|
      t.column :airline_id, :bigint, null: false
      t.string :name, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end

    create_table :crew_shift_taggings do |t|
      t.column :taggable_id, :bigint, null: false, index: true
      t.column :tag_id, :bigint, null: false, index: true
      t.string :context, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end

    add_index :crew_shift_tags, %i[airline_id name], unique: true
    add_index :crew_shift_taggings, %i[taggable_id tag_id], unique: true
    add_foreign_key :crew_shift_taggings, :crew_shift_tags, column: :tag_id
    add_foreign_key :crew_shift_taggings, :crew_shifts, column: :taggable_id
  end
end
