source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# UI/UX
gem 'jquery-rails'
gem 'bootstrap-sass' #bootstrap導入
gem 'font-awesome-rails' #アイコンタグを挿入するヘルパーメソッドを提供
gem 'wareki' #元号表示(平成や昭和など)に対応。案外使える
# ユーザー機能
gem 'devise' #ユーザー機能導入
gem 'devise-i18n' #devise日本語化
# 各種ファイル設定用
gem 'dotenv-rails' #ドットファイルの定義用
gem 'config' #定数定義用
gem 'enum_help' #enumの日本語化
# seed用
gem 'seed-fu'

# 検索機能
gem 'ransack'

# ページネーション
gem 'kaminari'

# パンくず
gem 'gretel'

# アップロード用
gem 'carrierwave'
gem 'mini_magick' #画像リサイズ用のgem
gem 'fog'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'better_errors'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'hirb'
  gem 'awesome_print'
  gem 'letter_opener' #メール送信機能をローカルで試すためのgem
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
