class User < ApplicationRecord
  attr_accessor :reset_token, :remember_token, :activation_token # виртуальные атрибуты
  has_many :notes

  before_create :create_activation_digest
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false },
            format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  validates :password, length: { minimum: 6 }, allow_blank: true

  has_secure_password # добавляет password, password_confirm. self.password_digest - возвр. хеш пароля и
  # self.authenticate('password') - вычисляет хеш пароля и сравнивает его с тем что в базе.
  # !!self.authenticate('password') or !!self.update({}) - замеч. пример привести обьект к логическому значению

  def remember
    self.remember_token = Todo::Digest.new_token
    update_attribute(:remember_digest, Todo::Digest.create_digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget_user
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token = Todo::Digest.new_token
    update_attribute(:reset_digest, Todo::Digest.create_digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def create_activation_digest
    self.activation_token = Todo::Digest.new_token
    self.activation_digest = Todo::Digest.create_digest(activation_token)
  end
end
