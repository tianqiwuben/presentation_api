require 'test_helper'

class PitchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pitch = pitches(:one)
  end

  test "should get index" do
    get pitches_url, as: :json
    assert_response :success
  end

  test "should create pitch" do
    assert_difference('Pitch.count') do
      post pitches_url, params: { pitch: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show pitch" do
    get pitch_url(@pitch), as: :json
    assert_response :success
  end

  test "should update pitch" do
    patch pitch_url(@pitch), params: { pitch: {  } }, as: :json
    assert_response 200
  end

  test "should destroy pitch" do
    assert_difference('Pitch.count', -1) do
      delete pitch_url(@pitch), as: :json
    end

    assert_response 204
  end
end
