# lastmod  9 marzo 2010  has_paper_trail
# lastmod  3 marzo 2009
# lastmod 25 febbraio 2009
# lastmod 19 dicembre 2008 (introduco cache per il pdf degli articoli)
# lastmod 27 novembre 2008
# lastmod 25 agosto 2008 ("has_many :page" diventa "has_many :pages" (order position); aggiunto acts_as_list)
# lastmod 11 luglio 2008
# lastmod 13 giugno 2008
# lastmod  9 maggio 2008
# lastmod  8 aprile 2008
# lastmod  5 aprile 2008
# lastmod  1 aprile 2008

class Article < ActiveRecord::Base
  has_paper_trail


  belongs_to :issue
  acts_as_list :scope => :issue

  has_many :pages, :order=>:position

  belongs_to :created_by, :foreign_key=>'created_by', :class_name=>'User'
  belongs_to :updated_by, :foreign_key=>'updated_by', :class_name=>'User'

  def sta_in
    pages=self.pages
    if !pages[0].nil?
      page = pages[0].pagenumber.nil? ? '?' : pages[0].pagenumber
    else
      page="?"
    end
    r = "#{self.issue.journal.title}, #{self.issue.numerazione}, pag. #{page.gsub(/^0*/,'')}"

    #if pages.size>1
    #  page = pages.last.pagenumber.nil? ? '?' : pages.last.pagenumber
    #  r << "-#{page.gsub(/^0*/,'')}"
    #end
    r
  end

  def pdf
    return nil if !self.pages.first.esiste_pdf
    self.pages.first.rails_imagepath
  end

  def pdf_list
    list=[]
    self.pages.collect {|p| list << [(p.pagenumber.blank? ? '?' : p.pagenumber),p.rails_imagepath]}
    list
  end

  def prepara_pdf_completo
    return self.cached_pdf if self.esiste_pdf_cached?
    tempdir = File.join(RAILS_ROOT, 'tmp')
    tf = Tempfile.new("article",tempdir)
    # pdf_file=tf.path + ".pdf"
    pdf_file=tf.path

    filelist = []
    self.pages.collect {|p| filelist << p.diskfilename}
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
    fd=File.open(self.pdf_cached_fname,'w')
    fd.write(data)
    fd.close
    data
  end
  def cached_pdf
    File.read(self.pdf_cached_fname)
  end
  def esiste_pdf_cached?
    fname=self.pdf_cached_fname
    return true if File.exists? fname and File.readable? fname and File.size(fname)>0
    false
  end
  def pdf_cached_fname
    File.join(InfoSistema.new.articles_cachedir,self.id.to_s+'.pdf')
  end

  def rivista
    self.issue.journal.title
  end

  def conta_pagine
    Page.count(:conditions => "article_id = #{self.id}")
  end
end
