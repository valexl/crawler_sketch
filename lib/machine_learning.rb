class MachineLearning
  include Singleton

  attr_reader :classifier

  IGNORE_WORDS = ['the', 'my', 'i', 'dont', 'of', 'for', 'and']

  def initialize
    @classifier = StuffClassifier::Bayes.new("Industries")
    @classifier.ignore_words = MachineLearning::IGNORE_WORDS
  end

  def self.classify(text)
    self.instance.classifier.classify(text)
  end

  def self.train(industry, phrase)
    self.instance.classifier.train(industry, phrase)
  end

end

