module Todo
  module Digest
    class << self
      def create_digest(str)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(str, cost: cost)
      end

      def new_token
        SecureRandom.urlsafe_base64
      end
    end
  end
end