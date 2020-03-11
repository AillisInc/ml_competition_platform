class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table "competition_versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.string "version"
      t.bigint "competition_id"
      t.string "dataset_location"
      t.text "note"
      t.boolean "archived", default: false
      t.boolean "remark", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.text "answer_data", limit: 4294967295
      t.integer "answer_data_size", default: 0
      t.index ["competition_id"], name: "index_competition_versions_on_competition_id"
    end

    create_table "competitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "title", default: ""
      t.text "note"
      t.integer "metrics_type"
      t.boolean "archived", default: false
      t.boolean "remark", default: false
    end

    create_table "predict_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.string "commit_hash", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "user_id"
      t.text "note"
      t.text "data", limit: 4294967295
      t.text "metrics_data", limit: 4294967295
      t.string "repository_name"
      t.bigint "competition_version_id"
      t.index ["competition_version_id"], name: "index_predict_logs_on_competition_version_id"
      t.index ["user_id"], name: "index_predict_logs_on_user_id"
    end

    create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.string "name", default: "", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "role", default: 0
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end

    add_foreign_key "competition_versions", "competitions", column: "competition_id"
    add_foreign_key "predict_logs", "competition_versions", column: "competition_version_id"
  end
end
