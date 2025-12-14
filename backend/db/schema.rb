# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_14_161831) do
  create_table "formularios", force: :cascade do |t|
    t.string "titulo"
    t.datetime "data_inicio"
    t.datetime "data_termino"
    t.integer "template_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.string "texto"
    t.string "tipo"
    t.boolean "obrigatoria"
    t.integer "ordem"
    t.text "opcoes"
    t.integer "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "resposta", force: :cascade do |t|
    t.text "data_resposta"
    t.string "status"
    t.integer "user_id", null: false
    t.integer "formulario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_resposta_on_formulario_id"
    t.index ["user_id"], name: "index_resposta_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "matricula"
    t.string "email"
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matricula"], name: "index_students_on_matricula", unique: true
    t.index ["turma_id"], name: "index_students_on_turma_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo_sigaa"
    t.string "nome"
    t.string "disciplina"
    t.string "semestre"
    t.integer "ano"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo_sigaa", "semestre"], name: "index_turmas_on_codigo_sigaa_and_semestre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "matricula"
    t.string "nome"
    t.string "password_digest"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "questaos", "templates"
  add_foreign_key "resposta", "formularios"
  add_foreign_key "resposta", "users"
  add_foreign_key "students", "turmas"
  add_foreign_key "templates", "users"
end
