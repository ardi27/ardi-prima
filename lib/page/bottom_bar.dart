import 'package:ardi_prima/page/english_page.dart';
import 'package:ardi_prima/page/suriname_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static List _tabPages = <Widget>[EnglishPage(), SurinamePage()];
  static const _tab = <Tab>[
    Tab(
      text: "English",
    ),
    Tab(text: "Suriname"),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabPages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: TabBarView(
        children: _tabPages,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(
          tabs: _tab,
          controller: _tabController,
        ),
      ),
    );
  }
}
