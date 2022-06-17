class Categorie {
  int id;
  int type_id;
  String type;
  String nom;
  double debit;
  double credit;
  double solde;
  //double solde = debit - credit;

  Categorie(
      {this.id, this.type_id, this.type, this.nom, this.debit, this.credit}) {
    solde = debit - credit;
  }

  static Categorie fromMap(Map map) {
    return Categorie(
      id: int.parse("" + map['id']),
      type_id: int.parse("" + map['type_id']),
      type: map['type'],
      nom: map['nom'],
      debit: map['debit'] == null ? 0 : double.parse("" + map['debit']),
      credit: map['credit'] == null ? 0 : double.parse("" + map['credit']),
    );
  }

  static Categorie fromSpecialMap(Map map) {
    return Categorie(
      id: int.parse("" + map['id']),
      type_id: int.parse("" + map['type_id']),
      type: map['type'],
      nom: map['nom'],
    );
  }

  @override
  String toString() {
    return 'Categorie{id: $id,type_id: $type_id,type: $type, nom: $nom, debit: $debit, credit: $credit, solde: $solde}';
  }
}
