require "test_helper"

class FormulariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @formulario = formularios(:one)
  end

  test "should get index" do
    get formularios_url, as: :json
    assert_response :success
  end

  test "should create formulario" do
    assert_difference("Formulario.count") do
      post formularios_url, params: { formulario: { data_inicio: @formulario.data_inicio, data_termino: @formulario.data_termino, template_id: @formulario.template_id, titulo: @formulario.titulo, turma_id: @formulario.turma_id } }, as: :json
    end

    assert_response :created
  end

  test "should show formulario" do
    get formulario_url(@formulario), as: :json
    assert_response :success
  end

  test "should update formulario" do
    patch formulario_url(@formulario), params: { formulario: { data_inicio: @formulario.data_inicio, data_termino: @formulario.data_termino, template_id: @formulario.template_id, titulo: @formulario.titulo, turma_id: @formulario.turma_id } }, as: :json
    assert_response :success
  end

  test "should destroy formulario" do
    assert_difference("Formulario.count", -1) do
      delete formulario_url(@formulario), as: :json
    end

    assert_response :no_content
  end
end
