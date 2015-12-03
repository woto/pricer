json.array!(@prices) do |price|
  json.extract! price, :id, :title, :supplier_id
  json.url price_url(price, format: :json)
end
