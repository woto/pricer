require "redis/connection/hiredis"
require "redis"
require "csv"
require 'pry'
require 'pry-nav'

$redis = Redis.new

def normalize_article(article)
	article.to_s.upcase.gsub(/[^А-ЯA-Z0-9]/i, '')
end

def normalize_brand(brand)
	brand
end

1.times do |i|
	next_offer_id_key = "next_offer_id:#{Date.today.yday()}"
	$redis.set(next_offer_id_key, 0)
	$redis.expire(next_offer_id_key, 864000)
	CSV.foreach('2.csv') do |row|
		price_id = i
		article = normalize_article(row[3])
		brand = normalize_brand(row[0])
		offer_id =  $redis.incr(next_offer_id_key)
		$redis.sadd("price:#{price_id}", offer_id)
		$redis.sadd("article:#{article}", offer_id)
		$redis.set("offer:#{offer_id}", row.to_s)
	end
end
