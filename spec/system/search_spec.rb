require 'rails_helper'

describe "検索のテスト", type: :system do
	let(:user) { create(:user) }
	let(:category) { create(:category) }
	let(:category2) { create(:category) }
	let(:post) { create(:post, user_id: user.id, category_id: category.id)}
	let(:post2) { create(:post, user_id: user.id, category_id: category.id) }
	let(:post3) { create(:post, user_id: user.id, category_id: category2.id) }
	let(:post4) { create(:post, user_id: user.id, category_id: category2.id, address: "神奈川県横浜市1-1-1") }
	let(:post5) { create(:post, user_id: user.id, category_id: category2.id, address: "神奈川県横浜市1-1-1") }
	before do
		visit new_user_session_path
		fill_in "user[email]", with: user.email
		fill_in "user[password]", with: user.password
		click_button "ログイン"
	end

	context "記事一覧画面への遷移" do
		it "遷移できる" do
			visit posts_path
			expect(current_path).to eq "/posts"
		end
	end
	context "表示の確認" do
		before do
			visit edit_post_path(post)
			fill_in "post[tag_list]", with: "tag1,tag2,tag3"
			click_button "編集"
			visit posts_path
		end
		it "記事が表示される" do
			expect(page).to have_content post.title
		end
		it "記事詳細リンクが表示される" do
			expect(page).to have_link(href: post_path(post))
		end
		it "記事にいいねリンクが表示される" do
			expect(page).to have_link(href: post_likes_path(post))
		end
		it "キーワードフォームが表示される" do
			expect(page).to have_field "keyword"
		end
		it "住所フォームが表示される" do
			expect(page).to have_field "address"
		end
		it "タグフォームが表示される" do
			expect(page).to have_field "search_tag"
		end
		it "新着順ラジオボタンが表示され、選択されている" do
			expect(page).to have_checked_field "sort", with: "新着順"
		end
		it "いいね順ラジオボタンが表示される" do
			expect(page).to have_unchecked_field "sort", with: "いいね順"
		end
		it "タグリンクが表示される" do
			expect(page).to have_link "tag1", href: search_path(search_tag: ",tag1", category: "", sort: "新着順")
			expect(page).to have_link "tag2", href: search_path(search_tag: ",tag2", category: "", sort: "新着順")
			expect(page).to have_link "tag3", href: search_path(search_tag: ",tag3", category: "", sort: "新着順")
		end
	end
	context "検索フォームの確認" do
		before do
			visit edit_post_path(post)
			fill_in "post[tag_list]", with: "tag"
			click_button "編集"

			visit edit_post_path(post2)
			fill_in "post[tag_list]", with: "tag2"
			click_button "編集"

			visit edit_post_path(post3)
			fill_in "post[tag_list]", with: "tag2"
			click_button "編集"

			visit edit_post_path(post4)
			fill_in "post[tag_list]", with: "tag2"
			click_button "編集"

			visit edit_post_path(post5)
			fill_in "post[tag_list]", with: "tag2"
			click_button "編集"

			visit posts_path
		end
		it "タグで絞り込み検索ができる" do
			click_link "tag2", match: :first

			expect(page).to_not have_content post.title
			expect(page).to have_content post2.title
			expect(page).to have_content post3.title
			expect(page).to have_content post4.title
			expect(page).to have_content post5.title
		end
		it "タグによる絞り込みに続いて、ジャンル検索ができる" do
			click_link "tag2", match: :first
			select category2.name, from: "category", match: :first
			click_button "検索", match: :first

			expect(page).to_not have_content post.title
			expect(page).to_not have_content post2.title
			expect(page).to have_content post3.title
			expect(page).to have_content post4.title
			expect(page).to have_content post5.title
		end
		it "タグ、ジャンルによる絞り込みに続いて、住所検索ができる" do
			click_link "tag2", match: :first
			select category2.name, from: "category", match: :first
			click_button "検索", match: :first
			fill_in "address", with: post4.address, match: :first
			click_button "検索", match: :first

			expect(page).to_not have_content post.title
			expect(page).to_not have_content post2.title
			expect(page).to_not have_content post3.title
			expect(page).to have_content post4.title
			expect(page).to have_content post5.title
		end
		it "タグ、ジャンル、住所による絞り込みに続いて、キーワード検索ができる" do
			click_link "tag2", match: :first
			select category2.name, from: "category", match: :first
			click_button "検索", match: :first
			fill_in "address", with: post4.address, match: :first
			click_button "検索", match: :first
			fill_in "keyword", with: post5.title, match: :first
			click_button "検索", match: :first

			expect(page).to_not have_content post.title
			expect(page).to_not have_content post2.title
			expect(page).to_not have_content post3.title
			expect(page).to_not have_content post4.title
			expect(page).to have_content post5.title
		end
	end
end
