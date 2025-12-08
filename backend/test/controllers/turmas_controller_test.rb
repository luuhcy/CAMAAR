require "test_helper"

class TurmasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @turma = turmas(:one)
  end

  test "should get index" do
    get turmas_url, as: :json
    assert_response :success
  end

  test "should create turma" do
    assert_difference("Turma.count") do
      post turmas_url, params: { turma: { ano: @turma.ano, codigo_sigaa: @turma.codigo_sigaa, disciplina: @turma.disciplina, nome: @turma.nome, semestre: @turma.semestre } }, as: :json
    end

    assert_response :created
  end

  test "should show turma" do
    get turma_url(@turma), as: :json
    assert_response :success
  end

  test "should update turma" do
    patch turma_url(@turma), params: { turma: { ano: @turma.ano, codigo_sigaa: @turma.codigo_sigaa, disciplina: @turma.disciplina, nome: @turma.nome, semestre: @turma.semestre } }, as: :json
    assert_response :success
  end

  test "should destroy turma" do
    assert_difference("Turma.count", -1) do
      delete turma_url(@turma), as: :json
    end

    assert_response :no_content
  end
end
