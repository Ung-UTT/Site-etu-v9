require 'test_helper'

class AssociationTest < ActiveSupport::TestCase
  test 'Ne doit pas enregistrer une association si il manque le nom, et/ou le président' do
    asso = Association.new
    assert !asso.save, 'rien'
    asso = Association.new(:name => 'King of UTT')
    assert !asso.save, 'seulement nom'
    asso = Association.new(:president => users(:kevin))
    assert !asso.save, 'seulement président'
  end

  test 'Ne doit pas enregistrer de doublons' do
    Association.create(:name => 'Winners', :president => users(:kevin))
    asso = Association.new(:name => 'Winners', :president => users(:joe))
    assert !asso.save
  end

  test 'Le président doit être valide' do
    u = User.new
    asso = Association.new(:name => 'Winners', :president => u)
    assert !asso.save
    asso = Association.create(:name => 'Winners', :president => users(:kevin))
    assert asso.president == users(:kevin)
  end

  test 'Doit enregistrer une association qui a le minimum de champs' do
    asso = Association.new(:name => 'King of UTT', :president => users(:kevin))
    assert asso.save
  end
  
  test 'Historique doit fonctionner' do
    asso = associations(:FritUTT)
    id = asso.id
    asso.name = "N'importe quoi"
    asso.save
    asso.name = 'Autre chose'
    asso.save
    
    asso = asso.previous_version
    asso.save
    assert Association.find(id).name == "N'importe quoi", '-1'
    asso.previous_version.save
    assert Association.find(id).name == 'FritUTT', '-2'
  end

  test 'Doit pouvoir avoir des associations filles et parentes' do
    fritutt = associations(:FritUTT)
    librutt = associations(:LibrUTT)

    assert librutt.parent == fritutt
    assert fritutt.children.include?(librutt)
  end
  
  test 'Doit pouvoir avoir des tags' do
    asso = associations(:BDE)
    asso.tag_list = 'Bureau, dès, Eh Léve !'
    assert asso.save
    assert asso.tags.map(&:name).include?('dès'), "Le tag n'est pas inclus"
  end

  test 'Peut avoir des rôles' do
    asso = associations(:BDE)
    singers = Role.create(:name => 'Chanteurs', :association => asso)
    assert asso.roles.include?(singers)
  end

  test 'Peut avoir des commentaires' do
    asso = associations(:BDE)
    com = Comment.create(:content => 'Wech les mecs', :user => users(:joe), :commentable => asso)
    assert asso.comments.include?(com)
  end

  test 'Peut avoir des documents' do
    asso = associations(:BDE)
    doc = create_document_with_name('favicon.gif')
    doc.documentable = asso
    doc.save
    assert asso.documents.include?(doc)
  end

  test 'Peut avoir des événements associés' do
    asso = associations(:BDE)
    event = events(:party)

    event.associations << asso
    assert asso.events.include?(event)
  end

  test 'Pouvoir être membre' do
    asso = associations(:BDE)
    joe = users(:joe)
    joe.roles << asso.member
    assert asso.users.include?(joe)
  end

  test 'Doit supprimer tout les contenus associés' do
    asso = associations(:BDE)
    asso.roles << Role.create(:name => 'gardiens')
    asso.comments << Comment.create(:content => 'Hey', :user => users(:joe))
    asso.documents << create_document_with_name('favicon.gif')
    asso.events << Event.create(:title => 'Truc de fou', :organizer => users(:joe))

    id = asso.id
    asso.destroy

    assert Role.find_by_association_id(id) == nil
    com = Comment.find_by_commentable_id(id)
    assert com.nil? ? true : com.select {|c| c.commentable_type == 'Association'}.empty?
    doc = Document.find_by_documentable_id(id)
    assert doc.nil? ? true : doc.select {|d| d.documentable_type == 'Association'}.empty?
    events = Event.all.select {|e| !e.associations.empty?}
    assert events.empty? ? true : events.select {|e| e.associations.map(&:id).include?(id) }.empty?
  end
end
