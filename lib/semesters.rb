# Ici sont définis les semestres de l'UTT

SEMESTERS = [
    # name : XXXXX : identifiant du semestre : P2012, A2012, P2013, ...
    # start_at : date du premier jour (en utilisant Date.new(année, mois, jour)) (un lundi)
    # end_at : date du dernier jour
    # weeks : semaines : tableau de chaînes, chacune représentant une semaine
      # Chaque jour peut se voir attribué une lettre :
      # R : jour de rentrée
      # A : jour A
      # B : jour B
      # V : pas cours (vacances, finaux, jours fériés, ...)
      # S : spécial (jour déplacé, ... ???)

  {
    'name' => 'P2012',
    'start_at' => Date.new(2012, 2, 20), # 20 février 2012
    'end_at' => Date.new(2012, 6, 30), # 30 juin 2012
    'weeks' => ['RRRRRR', 'AAAAAA', 'VVVVVV', 'BBBBBB', 'AAAAAA',
                'BBBBBB', 'AAAAAA', 'VBBBBB', 'BAAAAA', 'ABBBBB',
                'VVVVVV', 'BVAAAA', 'AABVVV', 'BBABBB', 'VASAAA',
                'BBBBBB', 'AAAAAA', 'BBBBBB', 'VVVVVV']
  },
]
