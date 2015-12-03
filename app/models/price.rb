class Price < ActiveRecord::Base

  attr_accessor :price_id

  validates :title, presence: true

  FIELDS = {
    'Каталожный номер' => 'catalog_number', 
    'Производитель' => 'brand',
    'Название' => 'title',
    'Цена' => 'cost',
    'Срок' => 'delivery_time',
    'Количество' => 'count', 
    'Кратность для заказа' => 'multiply_factor',
    'Штук в упаковке' => 'unit_package',
    'Единица измерения' => 'unit',
    'Масса' => 'weight',
    'Валюта' => 'currency',
    'ID товара' => 'external_id',
    'ID поставщика' => 'external_supplier_id',
    'Комментарий 0' => 'comment_0',
    'Комментарий 1' => 'comment_1',
    'Комментарий 2' => 'comment_2',
    'Комментарий 3' => 'comment_3',
    'Комментарий 4' => 'comment_4',
    'Комментарий 5' => 'comment_5',
    'Комментарий 6' => 'comment_6',
    'Комментарий 7' => 'comment_7',
    'Комментарий 8' => 'comment_8',
    'Комментарий 9' => 'comment_9',
    #'Замена (1)' => 'replacement_1',
    #'Замена (2)' => 'replacement_2',
    #'Замена (3)' => 'replacement_3',
    #'Замена (4)' => 'replacement_4',
    #'Замена (5)' => 'replacement_5',
    #'Название (английское)' => 'title_en',
    #'Название (группа)' => 'group',
    #'Название (описание)' => 'description',
    #'Название (линейка продукции)' => 'product_line',
    #'Название (применимость детали)' => 'applicability',
    #'Название (страна изготовитель)' => 'country',
    #'Название (комментарии)' => 'comment',
  }

end
