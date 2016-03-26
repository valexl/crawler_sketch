class Page

  def initialize(stage)
    @stage = stage
  end

  def industry
    industry   = try_to_find_industry_from_machine_learning
    industry ||= try_to_find_industry_by_the_most_frequent_words #TODO it should be used only on the first attempt. On all next attempts we should use only machine learning
    industry ||= try_to_find_industry_by_content #TODO it should be used only on the first attempt. On all next attempts we should use only machine learning
    
    # lear_machine!(industry) if industry.present?
    
    #I
      #1) get title
      #2) get meta[name=description]
      #3) Find some words which repeet several times
      #4) If only one word from this list andwe can think that it is industry 
    #II
      #1) get title
      #2) get meta[name=description]
      #3) If we can find words from industries list


    #title
    #meta[name=description]
  end

  private
    def lear_machine!(industry)
      MachineLearning.train(industry, title)
      MachineLearning.train(industry, meta_description)
    end

    def title
      @title ||= begin
                  @stage.search("title").text.to_s.strip 
                rescue NoMethodError => e
                  ''
                end
    end

    def meta_description
      @meta_description ||= begin
                            @stage.search("meta[name='description']").attr('content').to_s.strip  
                          rescue NoMethodError => e
                            ''
                          end
    end

    def words
      return @words if @words
      @words = title.split.map(&:downcase) + meta_description.split.map(&:downcase)
      @words.select! {|word| !MachineLearning::IGNORE_WORDS.include?(word) }
    end

    def the_most_frequent_words
      return @the_most_frequent_words if @the_most_frequent_words

      @the_most_frequent_words = words.inject({}) do |res,word| 
        res[word] = res[word].to_i + 1 
        res
      end
      @the_most_frequent_words.select! { |word, frequence| frequence > 2 }
      
      @the_most_frequent_words = @the_most_frequent_words.map{|k, v| k}
    end

    def try_to_find_industry_from_machine_learning
      value = MachineLearning.classify(title) || MachineLearning.classify(meta_description)
    end

    def try_to_find_industry_by_the_most_frequent_words
      suitable_industries = find_suitable_industries_via_es(the_most_frequent_words)

      industry_ids = suitable_industries.inject({}) do |res, record|
        res[record.id] = res[record.id].to_i + 1 
        res
      end.select {|record, frequence| frequence > 1 }.keys #get all industries from our database (Industry::LIST now) which appear several times
                                                          #TODO probably if we have only one the most frequent word and as a result we find only one ES record we can think that it is our industry

      if industry_ids.count == 1 #if we find more than 1 industry we can't say that algorithm detects it correctly
        IndustriesRepositories.find(industry_ids.first).title
      end
    end

    def try_to_find_industry_by_content
      all_potential_industries = find_suitable_industries_via_es(words)
      all_potential_industries = all_potential_industries.inject({}) do |res, record|
        res[record.id] = res[record.id].to_i + 1 
        res
      end
      industry_id, max_frequence = all_potential_industries.max_by{ |id, frequence|  frequence }
      #if there are several potential industries we can't say that algorithm detects it correctly
      return nil if all_potential_industries.select {|id, frequence| frequence == max_frequence }.count > 1
      IndustriesRepositories.find(industry_id).title
    end

    def find_suitable_industries_via_es(words_list)
      words_list.inject([]) do |res, word|
         res += IndustriesRepositories.search(query: { match: { title: word }} )
      end
    end

end


