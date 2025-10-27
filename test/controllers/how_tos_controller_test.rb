require "test_helper"

class HowTosControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get how_tos_show_url
    assert_response :success
  end
end
