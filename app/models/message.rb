class Message < ApplicationRecord
  validates :contents, presence: true
end
