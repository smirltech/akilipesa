class Compte {
  int id;
  int type_id;
  int categorie_id;
  String type;
  String categorie;
  String nom;
  double debit;
  double credit;
  double solde;

  Compte(
      {this.id,
      this.type_id,
      this.categorie_id,
      this.type,
      this.categorie,
      this.nom,
      this.debit,
      this.credit}) {
    solde = debit - credit;
  }

  static Compte fromMap(Map map) {
    return Compte(
      id: int.parse("" + map['id']),
      type_id: int.parse("" + map['type_id']),
      categorie_id: int.parse("" + map['categorie_id']),
      type: map['type'],
      categorie: map['categorie'],
      nom: map['nom'],
      debit: map['debit'] == null ? 0 : double.parse("" + map['debit']),
      credit: map['credit'] == null ? 0 : double.parse("" + map['credit']),
    );
  }

  static Compte fromSpecialMap(Map map) {
    return Compte(
        id: int.parse("" + map['id']),
        type_id: int.parse("" + map['type_id']),
        categorie_id: int.parse("" + map['categorie_id']),
        type: map['type'],
        categorie: map['categorie'],
        nom: map['nom']);
  }

  @override
  String toString() {
    return 'Compte{id: $id, type_id: $type_id, categorie_id: $categorie_id, type: $type,categorie: $categorie, nom: $nom, debit: $debit, credit: $credit, solde: $solde}';
  }
}
