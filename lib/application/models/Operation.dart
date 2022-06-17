class Operation {
  int id;
  String date;
  String detail;

  Operation({this.id, this.date, this.detail});

  static Operation fromMap(Map map) {
    return Operation(
        id: int.parse("" + map['id']),
        date: map['date'],
        detail: map['detail']);
  }

  @override
  String toString() {
    return 'Operation{id: $id, date: $date, detail: $detail}';
  }
}
