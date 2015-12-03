# -*- coding: utf-8 -*-

import codecs
import pdb

with codecs.open("/home/woto/rails/pricer/public/uploads/upload/price/110/TOYOTA_LEXUS.txt", 'r', 'CP1251') as f:
    text = f.readline()
    #pdb.set_trace()
    broken_text = text

    from recoder.cyrillic import Recoder
    rec = Recoder()
    #broken_text = u'Îñíîâíàÿ Îëèìïèéñêàÿ äåðåâíÿ â'
    fixed_text = rec.fix_common(broken_text)
    print fixed_text.encode('utf-8')
