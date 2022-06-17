String getAllTypes() {
  String sql = "SELECT id, nom FROM type";
  return sql;
}

String getAllCategories(int userid) {
  String sql =
      "SELECT cat.id id, cat.type_id type_id, gr.nom type, cat.nom nom, SUM(tr.debit) debit, SUM(tr.credit) credit , cat.userid userid";
  sql += " FROM categorie cat ";
  sql += " JOIN type gr ON cat.type_id = gr.id";
  sql += " LEFT JOIN compte cp ON cp.categorie_id = cat.id";
  sql += " LEFT JOIN transaction tr ON cp.id = tr.compte_id";

  sql += " WHERE  cat.userid = $userid";
  sql += " GROUP BY cat.nom";
  sql += " ORDER BY cat.nom";

  return sql;
}

String getAllComptes(int userid) {
  String sql =
      "SELECT cat.id id, cat.categorie_id categorie_id, ct.type_id type_id, gr.nom type, ct.nom categorie, cat.nom nom, SUM(tr.debit) debit, SUM(tr.credit) credit ";
  sql += " FROM compte cat ";
  sql += "  JOIN categorie ct ON cat.categorie_id = ct.id";
  sql += "  JOIN type gr ON ct.type_id = gr.id";
  sql += " LEFT JOIN transaction tr ON cat.id = tr.compte_id";
  sql += " WHERE cat.userid = $userid";
  sql += " GROUP BY cat.nom";
  sql += " ORDER BY cat.nom";

  return sql;
}

String getAllTransactions(int userid) {
  String sql =
      "SELECT tr.id id, cp.categorie_id categorie_id, ct.type_id type_id, tr.compte_id compte_id, ct.nom categorie, tp.nom type, cp.nom compte, tr.date date, tr.detail detail, tr.debit debit, tr.credit credit ";
  sql += " FROM transaction tr ";
  sql += " RIGHT JOIN compte cp ON tr.compte_id = cp.id ";
  sql += "  JOIN categorie ct ON cp.categorie_id = ct.id ";
  sql += "  JOIN type tp ON ct.type_id = tp.id ";
  sql += " WHERE tr.userid = $userid";
  sql += " ORDER BY tr.date DESC, tr.id ASC";

  return sql;
}

String getSaveCategorie(int type_id, String nom, int userid) {
  String sql = "INSERT INTO categorie ";
  sql += " (type_id, nom, userid) ";
  sql += " VALUES ($type_id, '$nom', $userid)";

  return sql;
}

String getDeleteCategorie(int categorie_id, int userid) {
  String sql = "DELETE FROM categorie WHERE ";
  sql += " id=$categorie_id AND userid = $userid";

  return sql;
}

String getUpdateCategorie(
    int categorie_id, int type_id, String categorie_nom, int userid) {
  String sql = "UPDATE categorie ";
  sql += " SET type_id='$type_id', nom='$categorie_nom'";
  sql += " WHERE id=$categorie_id AND userid=$userid";

  return sql;
}

String getSaveCompte(int categorie_id, String nom, int userid) {
  String sql = "INSERT INTO compte ";
  sql += " (categorie_id, nom, userid) ";
  sql += " VALUES ($categorie_id, '$nom', $userid)";

  return sql;
}

String getDeleteCompte(int compte_id, int userid) {
  String sql = "DELETE FROM compte WHERE ";
  sql += " id=$compte_id AND userid = $userid";

  return sql;
}

String getUpdateCompte(
    int compte_id, int categorie_id, String compte_nom, int userid) {
  String sql = "UPDATE compte ";
  sql += " SET categorie_id='$categorie_id', nom='$compte_nom'";
  sql += " WHERE id=$compte_id AND userid=$userid";

  return sql;
}

String getSaveTransaction(int compte_id, String date, String detail,
    String debit, String credit, int userid) {
  String sql = "INSERT INTO transaction ";
  sql += " (compte_id, date, detail, debit, credit, userid) ";
  sql +=
      " VALUES ('$compte_id', '$date', '$detail', '$debit', '$credit', $userid)";

  return sql;
}

String getUpdateTransaction(int trans_id, int compte_id, String date,
    String detail, String debit, String credit, int userid) {
  String sql = "UPDATE transaction ";
  sql +=
      " SET compte_id = '$compte_id', date = '$date', detail = '$detail', debit = '$debit', credit='$credit' ";
  sql += " WHERE id=$trans_id AND userid=$userid";

  return sql;
}

String getDeleteTransaction(int trans_id, int userid) {
  String sql = "DELETE FROM transaction WHERE ";
  sql += " id=$trans_id AND userid=$userid";

  return sql;
}

//----------------------------//

String getSaveProfile(
  String email,
  String password,
  String nom,
  String prenom,
  String sexe,
  String bio,
) {
  String sql = "INSERT INTO profile ";
  sql += " (email, password, nom, prenom, sexe, bio) ";
  sql += " VALUES ('$email', '$password', '$nom', '$prenom', '$sexe', '$bio')";

  return sql;
}

String getEditPassword(
    int userid, String email, String oldpass, String newpass) {
  String sql = "UPDATE profile ";
  sql += " SET password='$newpass'";
  sql += " WHERE id=$userid AND email='$email' AND password='$oldpass'";
  return sql;
}

String getEditProfileUM(
    int userid, String um) {
  String sql = "UPDATE profile ";
  sql += " SET um='$um'";
  sql += " WHERE id=$userid";
  return sql;
}

String getLastLogin(int userid) {
  String _date = DateTime.now().toString();
  String sql = "UPDATE profile ";
  sql += " SET last_login='$_date'";
  sql += " WHERE id=$userid";
  return sql;
}

// monnaie
String getAllUm() {
  String sql = "SELECT id, um, nom FROM monnaie ORDER BY nom ASC";
  return sql;
}

String getSaveUm(
  String um,
    String nom,
) {
  String sql = "INSERT INTO monnaie ";
  sql += " (um, nom) ";
  sql += " VALUES ('$um', '$nom')";

  return sql;
}

String getEditUm(int umid, String um, String nom) {
  String sql = "UPDATE monnaie ";
  sql += " SET um='$um', nom='$nom'";
  sql += " WHERE id=$umid";
  return sql;
}

String getDeleteUm(int umid) {
  String sql = "DELETE FROM monnaie WHERE ";
  sql += " id=$umid";

  return sql;
}
