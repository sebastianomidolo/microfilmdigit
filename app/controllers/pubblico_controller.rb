# lastmod 23 gennaio 2009
# lastmod 19 dicembre 2008 abbozzo metodo search
# lastmod 18 dicembre 2008 infopage
# lastmod 15 dicembre 2008 (layout "base" per pubblicazione del sito)
# lastmod 27 novembre 2008 (render partial pubblico/naviga_fascicolo)
# lastmod 25 agosto 2008
# lastmod 18 luglio 2008
# lastmod 11 luglio 2008
# lastmod 12 maggio 2008

class PubblicoController < ApplicationController

  layout "base"

  def infopage
    render :partial=>'pubblico/infopage', :layout=>true
  end

  def index
  end

  def dettaglio_rivista
    @rivista=Journal.find(params[:id])
    @fascicoli=@rivista.fascicoli_in_ordine
    render :partial=>'pubblico/dettaglio_rivista', :layout=>true
  end

  def toc
    @issue=Issue.find(params[:id])
  end
  def article_cover_jpg
    art = Article.find(params[:id])
    place_id = (params[:place_id])
    render :update do |page|
      html=render(:partial=>'/pubblico/naviga_fascicolo', :locals=>{:this_page_id=>art.pages[0].id})
      html<<link_to(image_tag("/pubblico/page_to_jpg/#{art.pages[0].id}", :width => '300px'),
        url_for(:controller=>'article', :action=>'pdf_articolo_completo',:id=>art.id),
                   {:title=>'Accesso al testo completo'})
      # html<<"<br/><b>#{art.sta_in}</b>"
      page[place_id].replace_html html
    end
  end
  def page_to_jpg
    page_id=params[:id]
    send_data(Page.find(page_id).pdf_2_jpg, :filename=>"page_#{page_id}.jpg",:disposition=>'inline',:type=>'image/jpeg')
  end

  def one_page_jpg
    place_id = params[:place_id]
    page_id = params[:page_id].to_i
    page=Page.find(page_id)
    art=page.article
    render :update do |page|
      html=render(:partial=>'/pubblico/naviga_fascicolo', :locals=>{:this_page_id=>page_id})
      html<<link_to(image_tag("/pubblico/page_to_jpg/#{page_id}", :width => '300px'),
                    url_for(:controller=>'article', :action=>'pdf_articolo_completo',:id=>art.id),
                    {:title=>'Accesso al testo completo'})
      html<<"<br/><b>#{art.sta_in}</b>"
      page[place_id].replace_html html
    end
  end

  def search
    @wt=params[:wt]
    if @wt.blank? or @wt.size<2
      @articles=[]
      @msg="Inserire un criterio di ricerca (minimo 2 caratteri)"
      @wt=''
    else
      @articles=Article.find(:all,:conditions=>"title ~* '#{@wt}'", :order=>'lower(title)')
    end
    if !@wt.blank?
      @msg="Trovati #{@articles.size} titoli"
      if @articles.size>100
        @articles=@articles[0..99]
        @msg << ", mostrati i primi 100"
      end

    end
    render :partial=>'pubblico/articles',:layout=>true
  end

end
