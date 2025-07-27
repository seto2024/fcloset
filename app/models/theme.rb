class Theme < ApplicationRecord
    validates :name, uniqueness: true
end
