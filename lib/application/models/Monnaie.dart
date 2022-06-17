class Monnaie {
  int id;
  String um;
  String nom;

  Monnaie({
    this.id,
    this.um,
    this.nom,
  });

  static Monnaie fromMap(Map map) {
    return Monnaie(
        id: int.parse("" + map['id']), um: map['um'], nom: map['nom']);
  }

  static Monnaie fromSpecialMap(Map map) {
    return Monnaie(
      id: int.parse("" + map['id']),
      um: map['um'],
      nom: map['nom'],
    );
  }

  static bool monnaiesContientNom(List<Monnaie> monnaies, String nom) {
    monnaies.forEach((element) {
      if (element.nom.toLowerCase() == nom.toLowerCase()) return true;
    });
    return false;
  }

  static bool monnaiesContientUM(List<Monnaie> monnaies, String um) {
    monnaies.forEach((element) {
      if (element.um.toLowerCase() == um.toLowerCase()) return true;
    });
    return false;
  }

  @override
  String toString() {
    return 'Mnnaie{id: $id, um: $um, nom: $nom}';
  }
}
