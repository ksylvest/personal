module Approvable
  extend ActiveSupport::Concern

  module Status
    ACTIVE = "active".freeze
    PENDING = "pending".freeze
  end

  STATUSES = [
    Status::ACTIVE,
    Status::PENDING,
  ].freeze

  included do
    validates :status, presence: true, inclusion: { in: STATUSES }
    before_validation -> { self.status ||= Status::ACTIVE }
  end

  def active?
    self.status.eql?(Status::ACTIVE)
  end

  def pending?
    self.status.eql?(Status::PENDING)
  end
end
