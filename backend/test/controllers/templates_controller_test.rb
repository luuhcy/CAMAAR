require "test_helper"

class TemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @template = templates(:one)
  end

  test "should get index" do
    get templates_url, as: :json
    assert_response :success
  end

  test "should create template" do
    assert_difference("Template.count") do
      post templates_url, params: { template: { descricao: @template.descricao, nome: @template.nome, user_id: @template.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show template" do
    get template_url(@template), as: :json
    assert_response :success
  end

  test "should update template" do
    patch template_url(@template), params: { template: { descricao: @template.descricao, nome: @template.nome, user_id: @template.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy template" do
    assert_difference("Template.count", -1) do
      delete template_url(@template), as: :json
    end

    assert_response :no_content
  end
end
