# lastmod 25 febbraio 2009  rails_imagepath; diskfilename
# lastmod 19 dicembre 2008
# lastmod 25 agosto 2008 (acts_as_list)
# lastmod 14 luglio 2008 (pdf_2_jpg)
# lastmod 19 giugno 2008
# lastmod  9 maggio 2008
# lastmod 17 aprile 2008
# lastmod  8 aprile 2008
# lastmod  5 aprile 2008
# lastmod  1 aprile 2008

class Page < ActiveRecord::Base
  belongs_to :article
  acts_as_list :scope => :article

  belongs_to :created_by, :foreign_key=>'created_by', :class_name=>'User'
  belongs_to :updated_by, :foreign_key=>'updated_by', :class_name=>'User'

  def to_label
    "#{self.pagenumber.to_i}"
  end

  def path_to_pdf
    Page.path_to_pdf(self.imagepath)
  end

  def diskfilename
    File.join(RAILS_ROOT, 'public', 'pdf', 'archives', imagepath)
    # File.join('/home', 'data', 'corriere_della_sera', imagepath)
  end

  def esiste_pdf
    File.exists?(File.join(RAILS_ROOT, 'public', 'pdf', 'archives',self.imagepath))
  end


  def rails_imagepath
    "/page/show_pdf/#{self.id}"
  end


  # Questa non dovrebbe essere piu' usata da quando esiste "rails_imagepath"
  def Page.path_to_pdf(imagepath)
    "#{File.join('/', 'pdf','archives',imagepath)}"
  end

  def Page.filename(imagepath)
    "#{File.join(RAILS_ROOT, 'public', 'pdf', 'archives',imagepath)}"
  end

  def sanifica_nomefile
    return true if self.esiste_pdf
    nome,estensione=self.imagepath.split('.')
    ['downcase','upcase'].each do |cmd|
      fn=nome+'.'+estensione.send(cmd)
      if File.exists?(Page.filename(fn))
        self.imagepath=fn
        self.save
        return true
      end
    end
    false
  end

  def pdf_2_jpg
    srcfile=(File.join(RAILS_ROOT, 'public', path_to_pdf))
    tempdir = File.join(RAILS_ROOT, 'tmp')
    tf = Tempfile.new("page",tempdir)
    jpg_file="#{tf.path}-000.jpg"
    # Per ragioni al momento (dicembre 2008) ignote a volte pdfimages produce un file pbm invece di jpg
    pbm_file="#{tf.path}-000.pbm"
    puts "jpg_file:#{jpg_file}"
    comando = "/usr/local/bin/pdfimages -f 1 -l 1 -j #{srcfile} #{tf.path}"
    data = nil
    if Kernel.system(comando)
      puts "Cerco di leggere #{jpg_file}"
      if File.exists?(jpg_file)
        fd = File.open(jpg_file)
        data = fd.read
        fd.close
        File.delete(jpg_file)
      else
        File.delete(pbm_file) if File.exists?(pbm_file)
        data=File.read(InfoSistema.new.anteprima_non_disponibile_fname)
      end
    end
    tf.close(true)
    data
  end

end
