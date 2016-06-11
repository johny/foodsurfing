class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


  has_many :meals

  has_many :shared_meals, through: :meal_shares, class_name: "Meal"


  has_attached_file :avatar, :styles => {
    :medium => "300x300#",
    :thumb => "100x100#" },
    :default_url => "avatar_missing_:style.png"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validate :address_is_required, :city_is_required
  validates_presence_of :name, message: "Podaj jak się nazywasz"

  attr_accessor :address_required


  def self.find_for_facebook_oauth(auth)


    user = User.where(provider: auth.provider, uid: auth.uid).first

    if user.nil?

      user = User.where(:email => email).first if auth.email

      if user.nil?
        user = User.new
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,12]
        user.name = auth.info.name
      else
        user.provider = auth.provider
        user.uid = auth.uid
      end

      user.save!

    end

    return user

  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def address_empty?
    return street_address.blank?
  end

  def address_required?
    return address_required
  end

  def can_order?(meal)

    !meal.participants.include?(self) && meal.user != self

  end


  private

    def address_is_required
      if address_required? && street_address.blank?
        errors.add(:street_address, "Twój adres jest wymagany")
      end
    end

    def city_is_required
      if address_required? && city.blank?
        errors.add(:city, "Twój adres jest wymagany")
      end
    end



end
