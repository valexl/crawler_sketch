namespace :data do

  namespace :load do
    desc 'Init ES Industries Repository'
    task :industries do
      IndustriesRepositories.destroy_index!
      Industry::LIST.each_with_index do |industry_title, index|
        IndustriesRepositories.es_repository.save(Industry.new('id' => index, 'title' => industry_title))
      end
      IndustriesRepositories.refresh_index!
    end
  end
  

end

