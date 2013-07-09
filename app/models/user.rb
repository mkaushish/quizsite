require 'digest'
require 'grade6'

class User < ActiveRecord::Base
  @@email_regex = /^[\w0-9+.!#\$%&'*+\-\/=?^_`{|}~]+@[a-z0-9\-]+(:?\.[0-9a-z\-]+)+$/i

  attr_accessor :password, :password_confirmation
  attr_accessible :email, :name, :password, :password_confirmation, :image
  serialize :problem_stats, Hash

  has_many :custom_problems, :class_name => 'Problem'
  has_many :answers, :dependent => :destroy
  has_many :quiz_instances, :dependent => :destroy
  has_many :quizzes, :through => :quiz_instances
  has_many :problem_set_instances, :dependent => :destroy
  has_many :problem_sets, :through => :problem_set_instances
  # has_many :problem_types # custom problems created by user
  has_many :problem_stats, :dependent => :destroy # mastery stats

  has_many :news_feeds

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  validates :email, :presence => true,
                    # :format => { :with => @@email_regex },
                    :uniqueness => { :case_sensitive => false },
                    :if => lambda{|a| a.new_record?}

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 },
                       :if => lambda{|a| a.new_record?}

  before_save  :encrypt_password

  before_create lambda { self.email.downcase! }

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  # the cookie stores both the userid and the salt, so if the user changes his password (and therefore salt), (s)he can
  # reset his cookie as well
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  # TODO this is currently not being run before create
  def generate_confirmation_code
    # TODO generate confirmation code in a more secure way? necessary?
    # rand is prob like 10 digits, + Time.now gives us a fair amount of security... I hope
    self.confirmation_code = secure_hash "#{Time.now.utc}--#{rand}"
  end

  def confiramtion_code()
    self.confiramtion_code ||= new_code
  end


  def confirm(code)
    if self.confirmation_code == code
      return self.confirmed = true
    end
    false
  end

  def confirmed?
    return self.confirmed
  end

  def stat(problem_type)
    puts "NOW PROBLEMTYPE = #{problem_type}"
    stats = problem_stats.where(:problem_type_id => problem_type.id)

    if stats.empty?
      return problem_stats.new(:problem_type_id => problem_type.id)
    else
      return stats.first
    end
  end

  def self.find_by_email(s)
    s.kind_of?(String) && super(s.downcase) 
  end

  def add_points!(p)
    self.points += p
    save(:validate => false)
  end

  private

  def encrypt_password
    if self.encrypted_password.nil? || !password.nil?
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
  end

  def encrypt(string)
    secure_hash "#{salt}--#{string}"
  end

  def make_salt
    secure_hash "#{Time.now.utc}--#{password}"
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def default_values
    self.confirmed ||= false
  end
end
