require "test_helper"

class CreatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @creator = creators(:one)
  end

  test "should get index" do
    get creators_url, as: :json
    assert_response :success
  end

  test "should create creator" do
    assert_difference('Creator.count') do
      post creators_url, params: { creator: { first_name: @creator.first_name, last_name: @creator.last_name } }, as: :json
    end

    assert_response 201
  end

  test "should show creator" do
    get creator_url(@creator), as: :json
    assert_response :success
  end

  test "should update creator" do
    patch creator_url(@creator), params: { creator: { first_name: @creator.first_name, last_name: @creator.last_name } }, as: :json
    assert_response 200
  end

  test "should destroy creator" do
    assert_difference('Creator.count', -1) do
      delete creator_url(@creator), as: :json
    end

    assert_response 204
  end
end
