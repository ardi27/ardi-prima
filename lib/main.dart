import 'package:ardi_prima/bloc/quotes_bloc.dart';
import 'package:ardi_prima/obs.dart';
import 'package:ardi_prima/page/bottom_bar.dart';
import 'package:ardi_prima/page/english_page.dart';
import 'package:ardi_prima/repository/quotes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                QuotesBloc(quotesRepository: QuotesRepository()))
      ],
      child: MaterialApp(
        title: "Ardi Prima",
        home: BottomBar(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
