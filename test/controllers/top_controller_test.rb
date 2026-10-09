require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "未ログインで main にアクセスすると login を表示" do
    get top_main_path
    assert_response :success
    assert_match "ログイン", response.body
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

  test "IDが違うとログイン失敗" do
    post top_login_path, params: { uid: "wrong", pass: "sanriko" }
    assert_response :success
    assert_match "IDまたはパスワードが違います", response.body
  end

  test "両方違うとログイン失敗" do
    post top_login_path, params: { uid: "x", pass: "y" }
    assert_response :success
    assert_match "IDまたはパスワードが違います", response.body
  end

  test "ログイン後は main が表示される" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    follow_redirect!
    assert_match "ログイン成功", response.body
  end

  test "空の入力ではログイン失敗" do
    post top_login_path, params: { uid: "", pass: "" }
    assert_response :success
    assert_match "IDまたはパスワードが違います", response.body
  end
end