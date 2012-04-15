class User < Sequel::Model
  def self.find_or_create_from_cas(ugid)
    user = find_or_create(ugid: ugid)
    return user
  end

  def to_s
    ugid
  end
end

