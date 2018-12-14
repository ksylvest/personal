class Attaching < ApplicationRecord
  belongs_to :attachment, touch: true
  belongs_to :document, polymorphic: true, touch: true
end
