class CreateProfils < ActiveRecord::Migration
  def change
    create_table :profils do |t|
      # Fiche trombi rempli par l'étudiant
      t.string     :utt_address
      t.string     :parents_address
      t.string     :surname # Surnom
      t.string     :once # Jadis

      # Fournis par l'UTT (pas modifiables)
      t.string     :utt_id
      t.string     :firstname
      t.string     :lastname
      t.string     :level
      t.string     :specialization
      t.string     :role

      # Surtout pour les profs
      t.string     :phone
      t.string     :room

      # Texte libre (passions, site, mails publiques, ...)
      t.text       :description

      # Est propre à un utilisateur, et contient sa photo de profil
      t.references :user
      t.references :image

      t.timestamps
    end
  end
end
