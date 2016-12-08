class User < ActiveRecord::Base
	attr_accessor  :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :message => "Email is already taken"
  validates_uniqueness_of :username, :message => "User Name is already taken"

  validate :check_password_and_confirmation

  def check_password_and_confirmation
    if password != password_confirmation
      errors.add(:password, "Not same as passowrd") 
    end
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
