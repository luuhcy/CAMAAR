require "test_helper"

class RespostaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @respostum = resposta(:one)
  end

  test "should get index" do
    get resposta_url, as: :json
    assert_response :success
  end

  test "should create respostum" do
    assert_difference("Respostum.count") do
      post resposta_url, params: { respostum: { data_resposta: @respostum.data_resposta, formulario_id: @respostum.formulario_id, status: @respostum.status, user_id: @respostum.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show respostum" do
    get respostum_url(@respostum), as: :json
    assert_response :success
  end

  test "should update respostum" do
    patch respostum_url(@respostum), params: { respostum: { data_resposta: @respostum.data_resposta, formulario_id: @respostum.formulario_id, status: @respostum.status, user_id: @respostum.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy respostum" do
    assert_difference("Respostum.count", -1) do
      delete respostum_url(@respostum), as: :json
    end

    assert_response :no_content
  end
end
