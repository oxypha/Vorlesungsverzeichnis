class Features
  extend FeatureFlipper

  flipper(:facebook) { Rails.env.production? }
  flipper :uservoice, false
  flipper(:analytics) { Rails.env.production? }

  flipper(:backdoor) { Rails.env.development? }
  flipper(:restrict_beta_access) { Features.public? }

  def self.public?
    Rails.env.production? || Rails.env.staging?
  end

end