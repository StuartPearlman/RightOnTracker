require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  
  has_many :trains, dependent: :destroy
  
  validates_uniqueness_of :phone
  validates_presence_of :phone

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