require "application_system_test_case"

class MySystemTest < ApplicationSystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 900]

  test "visit home page" do
    host! "example.com"  # 17(iii). host was deprecated
    visit root_path
    assert_text "Welcome"
  end
end