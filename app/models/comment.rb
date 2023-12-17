class Comment < ApplicationRecord

  # TODO: remove counter_cache and implement PostgrSQL trigger or a background job
  belongs_to :post, counter_cache: true

  belongs_to :account
end
