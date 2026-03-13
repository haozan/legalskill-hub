require 'rails_helper'

RSpec.describe WechatPayService, type: :service do
  describe '#call' do
    it 'can be initialized and called' do
      service = WechatPayService.new
      expect { service.call }.not_to raise_error
    end
  end
end
