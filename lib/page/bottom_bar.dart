import 'package:ardi_prima/bloc/quotes_bloc.dart';
import 'package:ardi_prima/page/english_page.dart';
import 'package:ardi_prima/page/suriname_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: Text(
        "English",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    ),
    Tab(
      child:
          Text("Suriname", style: TextStyle(color: Colors.black, fontSize: 16)),
    ),
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
    BlocProvider.of<QuotesBloc>(context)..add(FetchQuotes());
    return Scaffold(
      appBar: null,
      body: TabBarView(
        children: _tabPages,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          tabs: _tab,
          indicatorColor: Colors.green[700],
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 5,
          controller: _tabController,
        ),
      ),
    );
  }
}
