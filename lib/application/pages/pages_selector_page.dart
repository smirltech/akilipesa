import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/pages/categories_page.dart';
import 'package:akilipesa/application/pages/comptes_page.dart';
import 'package:akilipesa/application/pages/home_page.dart';
import 'package:akilipesa/application/pages/profile_page.dart';
import 'package:akilipesa/application/pages/transactions_page.dart';

class PagesSelectorPage extends StatefulWidget {
  PagesSelectorPage({Key key}) : super(key: key);

  @override
  _PagesSelectorPageState createState() => _PagesSelectorPageState();
}

class _PagesSelectorPageState extends State<PagesSelectorPage> {
  PageController pageController;
  int pageIndex = 2;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: pageIndex,
    );
  }

  _onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  _onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          CategoriesPage(),
          ComptesPage(),
          HomePage(),
          TransactionsPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: _onTap,
        activeColor: colorPrimary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              categoriesIcon,
              size: 20.0,
            ),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              comptesIcon,
              size: 20.0,
            ),
            title: Text('Comptes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              homeIcon,
              size: 40.0,
            ),
            title: Text('Accueil'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              transactionsIcon,
              size: 20.0,
            ),
            title: Text('Transactions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              profileIcon,
              size: 20.0,
            ),
            title: Text('Moi'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
