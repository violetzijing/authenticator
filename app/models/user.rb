class User < ApplicationRecord
    include Redis::Objects
    include BCrypt

    has_secure_password 

    def self.exists?(name)
        self.redis.exists? name
    end

    def self.create_user(name, password)
        salt = BCrypt::Engine.generate_salt
        hashed = Password.create(password + salt)
        self.redis.set(name, "#{hashed} #{salt}")
    end

    def get(name, password)
        return nil if !self.login?(name, password)
    end

    def self.login?(name, password)
        return false if !self.exists?(name)
        stored_password = self.redis.get(name).split(" ")
        hashed = stored_password[0]
        salt = stored_password[1]
        Password.new(hashed) == password + salt
    end

    def self.validate(name, password)
        msgs = []
        name_msgs = validate_name(name)
        password_msgs = validate_password(password)
        msgs << name_msgs if !name_msgs.nil?
        msgs << password_msgs if !password_msgs.nil?
        msgs.length > 0 ? msgs.join(" ") : nil
    end

    def self.validate_name(name)
        return "Empty username." if name.nil? || name.length == 0
    end

    def self.validate_password(password)
        return "Empty password." if password.nil? || password.length == 0
        if password.size < 8
            return "Must be at least 8 characters long."
        end

        if !(has_digits?(password) && has_uppercase_letters?(password) && has_downcase_letters?(password))
            return "Your password does not match the security requirements."
        end
    end

    private

    def self.has_uppercase_letters? password
        password.match(/[A-Z]/) ? true : false
    end

    def self.has_digits? password
        password.match(/\d/) ? true : false
    end

    def self.has_downcase_letters? password
        password.match(/[a-z]{1}/) ? true : false
    end
end
