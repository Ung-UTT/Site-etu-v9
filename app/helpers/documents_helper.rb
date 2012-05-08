module DocumentsHelper
  # Test if the current user can create a new document
  def cannot_create_doc?(documents)
    doc = documents.new
    res = cannot? :create, doc
    documents.delete(doc)
    res
  end
end
