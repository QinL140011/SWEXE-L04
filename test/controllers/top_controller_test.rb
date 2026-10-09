require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      uid: "kindai",
      pass: BCrypt::Password.create("sanriko")
    )
  end

  test "未ログインで main にアクセスすると login を表示" do
    get top_main_path
    assert_response :success
  end

  test "正しい認証情報でログイン成功" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    assert_redirected_to top_main_path
  end

  test "ログイン成功で session に uid が入る" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    assert_equal "kindai", session[:login_uid]
  end

  test "パスワードが違うとログイン失敗" do
    post top_login_path, params: { uid: "kindai", pass: "wrong" }
    assert_response :success
    assert_match "IDまたはパスワードが違います", response.body
  end

  test "存在しない uid ではログイン失敗" do
    post top_login_path, params: { uid: "nobody", pass: "sanriko" }
    assert_response :success
    assert_match "IDまたはパスワードが違います", response.body
  end

  test "ログアウトで session が削除される" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    assert_equal "kindai", session[:login_uid]

    get top_logout_path
    assert_nil session[:login_uid]
    assert_redirected_to top_main_path
  end
end