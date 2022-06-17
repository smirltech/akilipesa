class Type {
  int id;
  String nom;
  double debit = 0.0;
  double credit = 0.0;
  double solde() => debit - credit;
  //double solde = debit - credit;

  Type({
    this.id,
    this.nom,
  });

  static Type fromMap(Map map) {
    return Type(id: int.parse("" + map['id']), nom: map['nom']);
  }

  static Type fromSpecialMap(Map map) {
    return Type(
      id: int.parse("" + map['id']),
      nom: map['nom'],
    );
  }

  @override
  String toString() {
    return 'Type{id: $id, nom: $nom}';
  }
}
