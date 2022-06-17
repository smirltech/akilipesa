class Transaction {
  int id;
  int type_id;
  int categorie_id;
  int compte_id;
  String type;
  String categorie;
  String compte;
  String date;
  String detail;
  double debit;
  double credit;

  Transaction(
      {this.id,
      this.type_id,
      this.categorie_id,
      this.compte_id,
      this.type,
      this.categorie,
      this.compte,
      this.date,
      this.detail,
      this.debit,
      this.credit});

  static Transaction fromMap(Map map) {
    return Transaction(
      id: int.parse("" + map['id']),
      type_id: int.parse("" + map['type_id']),
      categorie_id: int.parse("" + map['categorie_id']),
      compte_id: int.parse("" + map['compte_id']),
      type: map['type'],
      categorie: map['categorie'],
      compte: map['compte'],
      date: map['date'],
      detail: map['detail'],
      debit: double.parse("" + map['debit']),
      credit: double.parse("" + map['credit']),
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, type_id: $type_id, categorie_id: $categorie_id, compte_id: $compte_id, type: $type, categorie: $categorie, compte: $compte, date: $date, detail: $detail, debit: $debit, credit: $credit}';
  }
}
