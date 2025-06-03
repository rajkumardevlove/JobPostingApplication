require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get applications_create_url
    assert_response :success
  end

  test "should get destroy" do
    get applications_destroy_url
    assert_response :success
  end

   test "should upload fixture file" do
    #17(iv) relative path deprecated
    uploaded_file = fixture_file_upload("files/sample.txt", "text/plain")

    # uploaded_file = fixture_file_upload(Rails.root.join("test/fixtures/files/sample.txt"), "text/plain")
    assert uploaded_file.present?
  end
end
