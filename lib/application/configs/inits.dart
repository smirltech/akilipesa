import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

final BASE_URL = 'https://apps.smirl.org/';

final BASE2_URL = 'http://169.254.243.114/'; // modem

final N_BASE2_URL = 'http://smirl-finance.dev/';
final N_BASE_URL = '${BASE_URL}smirl-finance/';

final GET_URL = '${N_BASE_URL}finance/get';
final SQL_URL = '${N_BASE_URL}finance/sql';
final A_LOGIN_URL = '${N_BASE_URL}profile/login';
final A_REGISTER_URL = '${N_BASE_URL}profile/sql';
final A_EDIT_PROFILE_URL = '${N_BASE_URL}profile/sqledit';

final URL_TEST = '${BASE_URL}/localhost';

Future<SharedPreferences> PREFS = SharedPreferences.getInstance();

IconData categoriesIcon = FontAwesome5.layer_group;
IconData comptesIcon = Icons.account_balance_wallet;
IconData homeIcon = Icons.home;
IconData transactionsIcon = Icons.swap_vert;
IconData profileIcon = Icons.account_circle;

String app_name = "AkiliPesa";
String app_version = "version 1.1.5(9)";
String website = "https://smirl.org";
String quote1 = "proud product of SmirlTech";

double default_icon_size = 16.0;
