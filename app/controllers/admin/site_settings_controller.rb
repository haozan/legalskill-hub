class Admin::SiteSettingsController < Admin::BaseController
  EDITABLE_KEYS = {
    "hero_video_url" => "首页引导视频链接（七牛云 mp4）",
    "hero_video_title" => "首页引导视频标题"
  }.freeze

  def edit
    @settings = EDITABLE_KEYS.map do |key, label|
      { key: key, label: label, value: SiteSetting.get(key).to_s }
    end
  end

  def update
    EDITABLE_KEYS.each_key do |key|
      val = params.dig(:site_settings, key).to_s.strip
      if val.present?
        SiteSetting.set(key, val)
      else
        SiteSetting.find_by(key: key)&.destroy
      end
    end
    redirect_to edit_admin_site_settings_path, notice: "设置已保存"
  end
end
