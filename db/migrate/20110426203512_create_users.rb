class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false, :default => ""
      t.string :email, :null => false, :default => ""

      # Fiche trombi rempli par l'étudiant
      t.string     :utt_address
      t.string     :parents_address
      t.string     :surname # Surnom
      t.string     :once # Jadis

      # Fournis par l'UTT (pas modifiables)
      t.integer    :utt_id
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

      t.timestamps
    end

    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end
end
