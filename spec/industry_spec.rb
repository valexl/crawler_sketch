require 'spec_helper'

RSpec.describe Industry do
  let(:url) { "#{"file:///#{Dir.pwd}/spec/fixtures/industries/#{@file_name}.html"}"}

  context '#self.get' do
    it 'returns SEO for http://www.capterra.com' do
      @file_name = 'capterra'
      expect(described_class.get(url)).to eq('Business Software & Services')
    end

    it 'returns SEO for http://blogs.capterra.com' do
      @file_name = 'blog_capterra'
      expect(described_class.get(url)).to eq('Business Software & Services')
    end
  end
end
