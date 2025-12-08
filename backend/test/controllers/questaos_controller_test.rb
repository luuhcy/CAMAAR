require "test_helper"

class QuestaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @questao = questaos(:one)
  end

  test "should get index" do
    get questaos_url, as: :json
    assert_response :success
  end

  test "should create questao" do
    assert_difference("Questao.count") do
      post questaos_url, params: { questao: { obrigatoria: @questao.obrigatoria, opcoes: @questao.opcoes, ordem: @questao.ordem, template_id: @questao.template_id, texto: @questao.texto, tipo: @questao.tipo } }, as: :json
    end

    assert_response :created
  end

  test "should show questao" do
    get questao_url(@questao), as: :json
    assert_response :success
  end

  test "should update questao" do
    patch questao_url(@questao), params: { questao: { obrigatoria: @questao.obrigatoria, opcoes: @questao.opcoes, ordem: @questao.ordem, template_id: @questao.template_id, texto: @questao.texto, tipo: @questao.tipo } }, as: :json
    assert_response :success
  end

  test "should destroy questao" do
    assert_difference("Questao.count", -1) do
      delete questao_url(@questao), as: :json
    end

    assert_response :no_content
  end
end
