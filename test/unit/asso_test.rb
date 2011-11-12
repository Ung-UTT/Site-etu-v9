require 'test_helper'

class AssoTest < ActiveSupport::TestCase
  test 'Ne doit pas enregistrer une asso si il manque le nom, et/ou le président' do
    asso = Asso.new
    assert !asso.save, 'rien'
    asso = Asso.new(:name => 'King of UTT')
    assert !asso.save, 'seulement nom'
    asso = Asso.new(:president => users(:kevin))
    assert !asso.save, 'seulement président'
  end

  test 'Ne doit pas enregistrer de doublons' do
    Asso.create(:name => 'Winners', :president => users(:kevin))
    asso = Asso.new(:name => 'Winners', :president => users(:joe))
    assert !asso.save
  end

  test 'Le président doit être valide' do
    u = User.new
    asso = Asso.new(:name => 'Winners', :president => u)
    assert !asso.save
    asso = Asso.create(:name => 'Winners', :president => users(:kevin))
    assert asso.president == users(:kevin)
  end

  test 'Doit enregistrer une asso qui a le minimum de champs' do
    asso = Asso.new(:name => 'King of UTT', :president => users(:kevin))
    assert asso.save
  end

  test 'Historique doit fonctionner' do
    asso = asso(:FritUTT)
    id = asso.id
    asso.name = "N'importe quoi"
    asso.save
    asso.name = 'Autre chose'
    asso.save

    asso = asso.previous_version
    asso.save
    assert Asso.find(id).name == "N'importe quoi", '-1'
    asso.previous_version.save
    assert Asso.find(id).name == 'FritUTT', '-2'
  end

  test 'Doit pouvoir avoir des asso filles et parentes' do
    fritutt = asso(:FritUTT)
    librutt = asso(:LibrUTT)

    assert librutt.parent == fritutt
    assert fritutt.children.include?(librutt)
  end

  test 'Peut avoir des rôles' do
    asso = asso(:BDE)
    singers = Role.create(:name => 'Chanteurs', :asso => asso)
    assert asso.roles.include?(singers)
  end

  test 'Peut avoir des commentaires' do
    asso = asso(:BDE)
    com = Comment.create(:content => 'Wech les mecs', :user => users(:joe), :commentable => asso)
    assert asso.comments.include?(com)
  end

  test 'Peut avoir des documents' do
    asso = asso(:BDE)
    doc = create_document_with_name('favicon.gif')
    doc.documentable = asso
    doc.save
    assert asso.documents.include?(doc)
  end

  test 'Peut avoir des événements associés' do
    asso = asso(:BDE)
    event = events(:party)

    event.asso << asso
    assert asso.events.include?(event)
  end

  test 'Pouvoir être membre' do
    asso = asso(:BDE)
    joe = users(:joe)
    joe.roles << asso.member
    assert asso.users.include?(joe)
  end

  test 'Doit supprimer tout les contenus associés' do
    asso = asso(:BDE)
    asso.roles << Role.create(:name => 'gardiens')
    asso.comments << Comment.create(:content => 'Hey', :user => users(:joe))
    asso.documents << create_document_with_name('favicon.gif')
    asso.events << Event.create(:title => 'Truc de fou', :organizer => users(:joe))

    id = asso.id
    asso.destroy

    assert Role.find_by_asso_id(id) == nil
    com = Comment.find_by_commentable_id(id)
    assert com.nil? ? true : com.select {|c| c.commentable_type == 'Asso'}.empty?
    doc = Document.find_by_documentable_id(id)
    assert doc.nil? ? true : doc.select {|d| d.documentable_type == 'Asso'}.empty?
    events = Event.all.select {|e| !e.asso.empty?}
    assert events.empty? ? true : events.select {|e| e.asso.map(&:id).include?(id) }.empty?
  end
end
