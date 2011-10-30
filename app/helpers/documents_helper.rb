module DocumentsHelper
  def cannot_create_doc?(documents)
    doc = documents.new
    res = cannot? :create, doc
    documents.delete(doc)
    return res
  end
end
