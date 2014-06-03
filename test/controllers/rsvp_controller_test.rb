require 'test_helper'

class RsvpControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
