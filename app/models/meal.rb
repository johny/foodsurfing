class Meal < ActiveRecord::Base

  belongs_to :user
  has_many :meal_shares
  has_many :users, through: :meal_shares

  alias_method :participants, :users

  has_attached_file :picture, :styles => {
      :large => "1440x720>",
      :medium => "720x360",
      :small => "360x180",
      :tiny => "180x90#"
    },
    :default_url => "missing_:style.png"

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :served_at, message: "Ustal porę kiedy posiłek będzie dostępny!"
  validates_presence_of :name, message: "Podaj nazwę dania"
  validates_presence_of :description, message: "Dodaj kilka słów opisu"
  validates_presence_of :portions, message: "Wybierz liczbę porcji"
  validates_presence_of :price_per_portion, message: "Podaj cenę za porcję"

  def to_marker_json

    return {
      name: name,
      lat: user.latitude,
      lng: user.longitude
    }.to_json

  end


  def shares_left?

    portions_used = meal_shares.inject(0) { |sum, share| sum + share.ordered_portions }

    return portions_used < portions

  end


  def available_portions

    portions_used = meal_shares.inject(0) { |sum, share| sum + share.ordered_portions }

    return 1..[portions - portions_used, 3].max

  end


end
