class Message < ApplicationRecord
  validates :contents, presence: true
  validates :contents, format: { with: /[.|-| ]*/, message: 'Messages can only contain ".", "-", and " ".' }
end
