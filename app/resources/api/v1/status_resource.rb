# == Schema Information
#
# Table name: statuses
#
#  id           :bigint           not null, primary key
#  updated_time :datetime         not null
#  valid_until  :datetime
#  status       :integer
#  queue        :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#
module Api
  module V1
    class StatusResource < ApplicationResource
      abstract
      immutable

      attributes :id, :updated_time, :valid_until, :status,
                 :queue, :store_id

      filter :store_id

      def updated_time
        if Rails.env.production?
          @model.updated_time
        else
          Time.now - rand(1..65).minutes
        end
      end

      def status
        if Rails.env.production?
          @model.status.nil? ? -1 : @model.status
        else
          rand(-1..10)
        end
      end

      def queue
        @model.queue.nil? ? -1 : @model.queue
      end

      filter :store_id, apply: ->(records, value, _options) {
        records.where(store_id: value)
      }
    end
  end
end
