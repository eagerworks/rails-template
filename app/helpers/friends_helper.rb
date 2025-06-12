module FriendsHelper
  def gender_options
    Friend.genders.keys.map do |gender|
      [gender.titleize, gender]
    end
  end
end
