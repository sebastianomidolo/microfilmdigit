class JournalsController < ApplicationController
  layout "base"
  
  def index
  end

  def show
    @journal=Journal.find(params[:id])
    @issues=@journal.fascicoli_in_ordine
  end

end
