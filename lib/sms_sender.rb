class SmsSender
  def self.deliver(mobile, message, sign: nil)
    sms = format("【%s】%s", sign || Figaro.env.YUNPIAN_SIGN, message)
    r = ChinaSMS.to(mobile, sms)
    raise "ChinaSMS error [mobile=#{mobile}]: #{r['detail']}" unless r["code"].zero?
  end
end
