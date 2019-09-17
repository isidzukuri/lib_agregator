# frozen_string_literal: true

module Library
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
  end
end
