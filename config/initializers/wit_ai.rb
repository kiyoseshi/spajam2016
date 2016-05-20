class Wit
  require 'wit'
  def initialize
    params[:access_token] = "Y3SKN3OLWR3LT57GRVRR6EZNAQF7MMMG"
    params[:action] = {
      :say => -> (session_id, context, msg) {
        p msg
      },
      :merge => -> (session_id, context, msg) {
        loc = first_entity_value entities, 'location'
        context['loc'] = loc unless loc.nil?
        return context
      },
      :error => -> (session_id, context, error) {
        p error.message
      },
      :'fetch-weather' => -> (session_id, context) {
        context['forecast'] = 'sunny'
        return context
      }
    }
  end
end

# initializeメソッドの書き方
# Witクラスのプロパティ
# 一度Railsじゃなくて普通のRubyファイルでWitクラスを定義してやってみる
# そもそもクラスでする必要なくて、githubのファイルをそのまま使えないのか
# 最終的にはコントローラーメソッド内で定義するのか否か
