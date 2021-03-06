class User < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_and_belongs_to_many :disciplines
  before_create :generate_timetable_id

  validates :uid, :name, :disciplines, :presence => true

  def generate_timetable_id
    self.timetable_id = SecureRandom.urlsafe_base64
  end

  def event_dates
    EventDate.joins(:event => :users).where("users.id" => User.first)
  end

  def authorize_status
    if new?
      if EarlyAccess.allowed?(uid)
        :signup
      else
        :no_beta
      end
    else
      :ok
    end
  end

  def new?
    discipline_ids.empty? || name.nil?
  end

  def self.sign_in(mail)
    user = find_by_uid(mail)
    if user.nil?
      user = new uid: mail
      user.save validate: false
    end
    user
  end

  def allow!
    EarlyAccess.add uid
  end

end
