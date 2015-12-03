class SearchForm
  include ActiveModel
  include ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Dirty

	attr_accessor :catalog_number

	def persisted?
		false
	end

  def initialize(attr={})
    self.catalog_number = attr[:catalog_number]
  end

end
