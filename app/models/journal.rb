# lastmod  6 febbraio 2009
# lastmod 23 gennaio 2009
# lastmod 18 dicembre 2008 (titoli_pubblicati)
# lastmod 25 agosto 2008 ("has_many :issue" diventa "has_many :issues")
# lastmod 27 luglio 2008 (aggiunto :order=>:position)
# lastmod 18 luglio 2008 (fascicoli_in_ordine)
# lastmod 10 luglio 2008
# lastmod 13 giugno 2008
# lastmod  6 maggio 2008
# lastmod  5 aprile 2008
# lastmod  1 aprile 2008

class Journal < ActiveRecord::Base
  has_many :issues, -> { order 'position' }

  belongs_to :created_by, :foreign_key=>'created_by', :class_name=>'User'
  belongs_to :updated_by, :foreign_key=>'updated_by', :class_name=>'User'

  # has_many :fascicoli_ordinati, :class_name=>'Issue', :order=>'anno,lower(fascicolo)'

  def to_label
    self.title
  end

  def fondi_con_altro_titolo(altro_titolo)
    return nil if altro_titolo.id==self.id
    altro_titolo.issue.update_all("journal_id=#{self.id}")
    self
  end

  def fascicoli_in_ordine
    Issue.find_by_sql %Q{
     SELECT DISTINCT i.id,i.fascicolo,i.annata,i.info_fascicolo,i.bobina,min(p.sequential) AS sequenziale
      FROM issues i,articles a,pages p
      WHERE i.journal_id=#{self.id} AND a.issue_id=i.id AND p.article_id=a.id
      GROUP BY i.id,i.fascicolo,i.annata,i.info_fascicolo,i.bobina ORDER BY i.bobina,sequenziale;
    }
  end

  def annate
    issues.first
  end

  # 23 gennaio 2009: ho inserito un attributo "pubblicato" su journals: questa proc non serve piu'
  # 17 dicembre 2008: escludo id 29,30
  # 15 dicembre 2008: escludo id 30
  # def Journal.conditions_for_titoli_pubblicati
  #   'id not in(29,30)'
  # end

  def Journal.titoli_pubblicati
    # conditions=Journal.send('conditions_for_titoli_pubblicati')
    Journal.find(:all,:include=>:issues,:order=>'keytit',:conditions=>'pubblicato')
  end
  def Journal.titoli_pubblicati_ids
    ids=[]
    Journal.find(:all,:select=>'id',:conditions=>'pubblicato').each do |r|
      ids<<r.id
    end
    ids
  end

end
