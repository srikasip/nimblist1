require 'test_helper'

class MailgunsControllerTest < ActionController::TestCase
  setup do
    @mailgun = mailguns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mailguns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mailgun" do
    assert_difference('Mailgun.count') do
      post :create, mailgun: { recipient: @mailgun.recipient, sender: @mailgun.sender, stripped-text: @mailgun.stripped-text, subject: @mailgun.subject }
    end

    assert_redirected_to mailgun_path(assigns(:mailgun))
  end

  test "should show mailgun" do
    get :show, id: @mailgun
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mailgun
    assert_response :success
  end

  test "should update mailgun" do
    patch :update, id: @mailgun, mailgun: { recipient: @mailgun.recipient, sender: @mailgun.sender, stripped-text: @mailgun.stripped-text, subject: @mailgun.subject }
    assert_redirected_to mailgun_path(assigns(:mailgun))
  end

  test "should destroy mailgun" do
    assert_difference('Mailgun.count', -1) do
      delete :destroy, id: @mailgun
    end

    assert_redirected_to mailguns_path
  end
end
