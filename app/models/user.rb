require 'bcrypt'

class User < ActiveRecord::Base
  validates_uniqueness_of :phone
  include BCrypt
  has_many :trains

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def logged_in?(session)
    session[:id] == id
  end
end