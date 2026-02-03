# My Diet Story 画面遷移図 チェック結果

**実施日**: 画面遷移図に基づくチェックと最小修正を実施済み。

## 一覧：未実装・未定義・不備（修正前）

### 1. 未実装の画面
| 画面名 | 状態 | 備考 |
|--------|------|------|
| **お問い合わせフォーム** | 未実装 | ホームトップからのリンク・フォーム・送信後の遷移なし |
| **ストーリー一覧** | 未実装 | ヘッダーにリンクなし。掲示板一覧と同一または別画面の要否要確認 |

### 2. 未定義・重複のルート
| 内容 | 状態 |
|------|------|
| `resources :users` が2回定義されている（3行目と21行目） | 重複 |
| お問い合わせ用ルート（例: `get 'contact'`） | 未定義 |
| ストーリー一覧用ルート | 未定義（掲示板一覧と兼用なら不要） |
| **投稿一覧（自分の投稿のみ）** | 未定義。現在「投稿一覧」= 全投稿一覧になっている |

### 3. 必要なアクション・コントローラ
| 場所 | 内容 |
|------|------|
| **UsersController#follows / #followers** | `@user` を設定していない。ビューで `user: @user` を渡しているが、`user = User.find(...)` のままなので `@user` が nil |
| **お問い合わせ** | ContactsController の new / create、または homes#contact など未実装 |

### 4. リンク・表示の不備
| 画面・要素 | 不備 |
|------------|------|
| **ヘッダー** | 未ログイン時に非表示。図では ロゴ・新規登録・ログイン・掲示板一覧 等を表示想定 |
| **ヘッダー** | 「掲示板一覧」と「投稿一覧」の役割が逆。図では 掲示板一覧=全投稿、投稿一覧=自分の投稿 |
| **ヘッダー** | 「ストーリー一覧」リンクなし |
| **ホームトップ** | 「お問い合わせ」リンクなし |
| **下書き一覧** | Backボタンなし（図では Back→掲示板一覧 or ヘッダー） |
| **フォロー一覧・フォロワー一覧** | Backボタンなし（図では Back→掲示板一覧） |
| **ユーザ編集** | 退会ボタンなし（図では 退会→ログイン画面） |
| **掲示板一覧（posts#index）** | 画面タイトルが「投稿一覧」のまま。図では「掲示板一覧」 |

### 5. 遷移の確認（図どおりか）
| 遷移 | 現状 |
|------|------|
| ログイン/新規登録後 → 掲示板一覧 | Devise の after_sign_in_path 等未設定の可能性（要確認） |
| 投稿詳細の「編集」→ 投稿編集 | 実装済み（edit_post_path） |
| 投稿編集保存後 → 投稿詳細 | 実装済み |
| 下書き一覧の「投稿編集」→ 投稿一覧（自分の） | 下書きの編集リンクは post 詳細 or edit へ。図では「投稿一覧」へ |

---

## 最小修正（どのファイルをどう直すか）

1. **config/routes.rb**  
   - 先頭の `resources :users` を削除し、1か所にまとめる。  
   - 投稿一覧（自分の）用に `get 'my_posts', to: 'posts#index', ...` のように collection を追加するか、`posts#index` で `current_user` のみにスコープするクエリパラメータを検討する。

2. **app/controllers/users_controller.rb**  
   - `follows` と `followers` 内で `@user = User.find(params[:id])` を設定する。

3. **app/views/layouts/application.html.erb**  
   - 未ログイン時もヘッダーを表示し、「ロゴ」「新規登録」「ログイン」「掲示板一覧」を出す。  
   - ログイン時は「掲示板一覧」「投稿一覧（自分の）」「下書き一覧」「マイページ」「ストーリー一覧」「ログアウト」など図に合わせる。  
   - 「掲示板一覧」= `posts_path`、「投稿一覧」= 自分の投稿一覧用 path に変更。

4. **app/views/homes/top.html.erb**  
   - 「お問い合わせ」リンクを追加（まずは `#` や contact_path の仮ルートでも可）。

5. **app/views/posts/confirm.html.erb**  
   - 「Back」ボタンを追加し、`posts_path` または root_path へリンク。

6. **app/views/users/follows.html.erb / followers.html.erb**  
   - Backボタンを追加し、`posts_path` へリンク。  
   - パーシャルに渡す `user` は `@user` にそろえる（上記コントローラ修正で対応）。

7. **app/views/posts/index.html.erb**  
   - タイトルを「掲示板一覧」に変更（自分の投稿一覧と分ける場合）。

8. **投稿一覧（自分の）**  
   - `posts#index` に `?my_posts=1` のようなパラメータで「自分の投稿のみ」を表示する、または `collection get :my_posts` で別アクションにする。

9. **お問い合わせ（最小）**  
   - `get 'contact', to: 'homes#contact'`、`homes#contact` でフォーム表示、送信は mailto または「送信しました」の表示だけでも可。

10. **ユーザ編集**  
    - 退会ボタンは「削除」＋ログイン画面へリダイレクトの最小実装で対応可能。

---

## 評価が高くなる修正（ポートフォリオ向け）

1. **お問い合わせ**  
   - Contact モデル＋ContactsController で保存、または ActionMailer で送信し、送信完了画面→ホームトップへ遷移。

2. **ストーリー一覧**  
   - 掲示板一覧と別コンセプトなら、ストーリー用のルート・コントローラ・ビューを用意し、ヘッダーから遷移できるようにする。

3. **退会**  
   - 退会確認モーダルや専用ページを用意し、ユーザーを論理削除（または物理削除）してからログイン画面へリダイレクト。Devise の `destroy_user_registration_path` と連携してもよい。

4. **検索結果**  
   - 検索専用の URL（例: `posts/search?q=...`）と「検索結果」用のビューを用意し、検索ボタン→検索結果一覧→投稿詳細の流れを明確にする。

5. **ヘッダー**  
   - ロゴ画像、レスポンシブメニュー、ログイン/未ログインで表示を切り替える部分をコンポーネント化し、見た目と遷移を図と完全に揃える。

6. **画面タイトル・パンくず**  
   - 各画面で `content_for :title` とパンくずリストを統一し、今どの画面にいるかを明確にする。

7. **単体・結合テスト**  
   - 主要な画面遷移（ログイン→掲示板一覧、投稿一覧→詳細→編集など）をシステムテストでカバーする。

---

## 実施した最小修正の一覧

| 修正内容 | ファイル |
|----------|----------|
| ルート重複削除・contact・my_posts 追加 | config/routes.rb |
| follows/followers で @user を設定 | app/controllers/users_controller.rb |
| my_posts アクション追加・index/show を未ログインでも表示 | app/controllers/posts_controller.rb |
| contact / contact_submit アクション追加 | app/controllers/homes_controller.rb |
| ヘッダー未ログイン表示・掲示板一覧/投稿一覧/ストーリー一覧のリンク整理 | app/views/layouts/application.html.erb |
| お問い合わせリンク追加 | app/views/homes/top.html.erb |
| お問い合わせフォーム画面・送信後トップへ | app/views/homes/contact.html.erb（新規） |
| 掲示板一覧/投稿一覧のタイトル切り替え・検索 path 対応 | app/views/posts/index.html.erb, _index.html.erb |
| 下書き一覧に Back ボタン | app/views/posts/confirm.html.erb |
| フォロー・フォロワー一覧に Back ボタン・@user 利用 | app/views/users/follows.html.erb, followers.html.erb |
| ユーザ編集に「掲示板一覧へ戻る」「退会する」 | app/views/users/edit.html.erb |
| ストーリー一覧 | 掲示板一覧（posts_path）と同じ画面としてヘッダーにリンク追加 |
