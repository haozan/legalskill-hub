class SmsSender
  # 云片模板发送接口（避免智能匹配失败）
  # 使用默认模板 tpl_id=1：【#company#】您的验证码是#code#
  TPL_ID = 1
  YUNPIAN_TPL_URL = "https://sms.yunpian.com/v2/sms/tpl_single_send.json".freeze

  def self.deliver(mobile, code)
    apikey  = Figaro.env.YUNPIAN_API_KEY
    company = Figaro.env.YUNPIAN_SIGN  # 签名，如"深圳青狮科技"

    tpl_value = URI.encode_www_form(
      "#company#" => company,
      "#code#"    => code.to_s
    )

    response = Net::HTTP.post_form(
      URI(YUNPIAN_TPL_URL),
      "apikey"    => apikey,
      "mobile"    => mobile,
      "tpl_id"    => TPL_ID.to_s,
      "tpl_value" => tpl_value
    )

    result = JSON.parse(response.body)
    unless result["code"] == 0
      raise "云片短信发送失败 [mobile=#{mobile}]: code=#{result['code']} msg=#{result['msg']} detail=#{result['detail']}"
    end

    result
  end
end
