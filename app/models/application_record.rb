class ApplicationRecord
  def self.generate_key
    cid = ('a'..'z').to_a.sample+(Time.now.to_f * 1000).to_s[1,12]+(rand(10 ** 10).to_s.rjust(10,'0')+rand(10 ** 10).to_s.rjust(10,'0'))[1,15]
    Digest::MD5.hexdigest(cid)
  end
end
