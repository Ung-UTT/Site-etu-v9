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

  test 'Doit supprimer tout les contenus associés' do

  end

  test 'Doit enregistrer une association qui a le minimum de champs' do
    asso = Association.new(:name => 'King of UTT', :president => users(:kevin))
    assert asso.save
  end
end
