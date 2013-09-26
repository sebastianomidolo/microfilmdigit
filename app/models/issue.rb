# lastmod 25 febbraio 2009 (modifica prepara_pdf_completo, uso page.diskfilename)
# lastmod  8 ottobre 2008 (prepara_pdf_completo)
# lastmod 25 agosto 2008 ("has_many :article" diventa "has_many :articles" (order position))
# lastmod 28 luglio 2008 (introduco acts_as_list)
# lastmod 14 luglio 2008 (copertina, copertina_jpg)
# lastmod 11 luglio 2008
# lastmod 13 giugno 2008
# lastmod  9 maggio 2008
# lastmod  5 aprile 2008
# lastmod  1 aprile 2008

class Issue < ActiveRecord::Base
  belongs_to :journal
  acts_as_list :scope => :journal

  has_many :articles, :order=>:position

  belongs_to :created_by, :foreign_key=>'created_by', :class_name=>'User'
  belongs_to :updated_by, :foreign_key=>'updated_by', :class_name=>'User'

  def to_label
    "#{self.anno}/#{self.fascicolo}"
  end

  def numerazione
    r = "#{self.annata}, #{self.fascicolo}"
    r << " (#{self.info_fascicolo})" if self.info_fascicolo!=self.annata
    r
  end

  def table_of_contents
    sql = %Q{
      SELECT DISTINCT a.title, a.id, min(p.sequential) AS sequential
        FROM articles a, pages p
        WHERE a.issue_id=#{self.id} AND p.article_id=a.id
        GROUP BY a.issue_id,a.id,a.title ORDER BY sequential;}
    Article.find_by_sql sql
  end

  def copertina
    sql = %Q{
      SELECT p.* FROM articles a, pages p
       WHERE a.issue_id=#{self.id} AND p.article_id=a.id ORDER BY sequential limit 1;
    }
    p=Page.find_by_sql sql
    p.nil? ? nil : p[0]
  end
  def copertina_jpg
    p=self.copertina
    return nil if p.nil?
    p.pdf_2_jpg
  end

  def prepara_pdf_completo
    tempdir = File.join(RAILS_ROOT, 'tmp')
    tf = Tempfile.new("issue",tempdir)
    pdf_file=tf.path
    filelist = []
    self.articles.each do |article|
      article.pages.collect {|p| filelist << p.diskfilename}
    end
    filelist = filelist.join(' ')
    comando = "/usr/local/bin/gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=#{pdf_file} #{filelist}"
    if Kernel.system(comando)
      fd = File.open(pdf_file)
      data = fd.read
      fd.close
      msg = "ok"
    else
      msg = "err"
    end
    tf.close(true)
    data
  end


end
