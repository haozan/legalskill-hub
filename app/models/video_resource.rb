class VideoResource < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :bilibili_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
  validates :category, presence: true
  validates :views_count, numericality: { greater_than_or_equal_to: 0 }

  # 自动获取B站视频封面图
  def fetch_cover_image
    return nil if bilibili_url.blank?
    
    # 从URL中提取BVID
    bvid = bilibili_url.gsub('https://www.bilibili.com/video/', '').gsub('/', '')
    return nil if bvid.blank?
    
    begin
      # 调用B站API获取视频信息
      uri = URI.parse("https://api.bilibili.com/x/web-interface/view?bvid=#{bvid}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      
      if response.code == '200'
        data = JSON.parse(response.body)
        if data['code'] == 0 && data['data']
          return data['data']['pic']
        end
      end
    rescue => e
      Rails.logger.error "Failed to fetch Bilibili cover: #{e.message}"
    end
    
    nil
  end

  # 获取封面图（优先使用自定义封面，否则尝试获取B站封面）
  def cover_image_url
    cover_image.presence || fetch_cover_image
  end

  def increment_views!
    increment!(:views_count)
  end
end
