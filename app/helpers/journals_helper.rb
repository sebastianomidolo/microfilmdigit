module JournalsHelper
  def journal_opac_preview(record)
    return nil if record.clavis_manifestation_id.nil?
    %Q{<iframe src="http://bct.comperio.it/opac/detail/badge/sbct:catalog:#{record.clavis_manifestation_id}?height=300&showabstract=1&coversize=normal" frameborder="0" width="600" height="300"></iframe>}.html_safe
  end
end
