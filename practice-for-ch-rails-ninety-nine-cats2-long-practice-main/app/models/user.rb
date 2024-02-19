class User < ApplicationRecord
    validates :username, :session_token, :password_digest,presence: true
    validates :username, :session_token, uniqueness: true

    before_validation :ensure_session_token
    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user 
        else 
            return nil
        end 
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password) 
    end

    def reset_session_token!
        # this will create new unique session token
        self.session_token = generate_unique_session_token  
        self.save!
        self.session_token
    end

   

    private
    def generate_unique_session_token
        #to generate a unique token using SecureRandom.
        SecureRandom::urlsafe_base64
    end

    def ensure_session_token
        # use session_token we already have, if we dont have one, then  make one!
        self.session_token ||= SecureRandom::urlsafe_base64
    end 

end
