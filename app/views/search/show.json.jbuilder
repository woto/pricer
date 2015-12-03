json.array!(@results) do |result|
  json.merge! result
  #json.extract! result
  #json.extract! price, :id, :title, :supplier_id
  #json.url price_url(price, format: :json)
end
