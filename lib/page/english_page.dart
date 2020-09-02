import 'dart:math';

import 'package:ardi_prima/bloc/quotes_bloc.dart';
import 'package:ardi_prima/model/quotes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:shimmer/shimmer.dart';

class EnglishPage extends StatefulWidget {
  EnglishPage({Key key}) : super(key: key);

  @override
  _EnglishPageState createState() => _EnglishPageState();
}

class _EnglishPageState extends State<EnglishPage> {
  final _scrollController = ScrollController();
  QuotesBloc _quotesBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _quotesBloc = BlocProvider.of<QuotesBloc>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll == currentScroll) {
      _quotesBloc.add(FetchQuotes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "English Quotes",
          style: TextStyle(color: Colors.green[900]),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[400],
      body: Container(
        child: BlocListener<QuotesBloc, QuotesState>(
          listener: (context, state) {
            if (state is QuotesError) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<QuotesBloc, QuotesState>(
            builder: (context, state) {
              if (state is QuotesInitial) {
                return buildLoading();
              } else if (state is QuotesLoaded) {
                if (state.quotes.isEmpty) {
                  return Center(
                    child: Text("No Data"),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.quotes.length
                        ? bottomLoading()
                        : quotesWidget(state.quotes[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.quotes.length
                      : state.quotes.length + 1,
                );
              } else if (state is QuotesError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        color: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _quotesBloc.add(FetchQuotes());
                        }),
                  ),
                );
              }
              return buildLoading();
            },
          ),
        ),
      ),
    );
  }
}

Widget buildLoading() {
  return Container(
    color: Colors.white,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 24,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 24,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 24,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 120,
                                height: 24,
                                color: Colors.white,
                              )
                            ],
                          ))
                        ],
                      ),
                    )),
          ),
        )
      ],
    ),
  );
}

Widget bottomLoading() {
  return Container(
    alignment: Alignment.center,
    child: Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
    ),
  );
}

Widget quotesWidget(Quotes quotes) {
  return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: RoundedLetter(
          text: quotes.author.substring(0, 1),
          shapeSize: 50,
          fontSize: 24,
          shapeColor: Color.fromRGBO(Random().nextInt(255),
              Random().nextInt(255), Random().nextInt(255), 1),
        ),
        title: Text(
          quotes.author,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quotes.en,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            quotes.rating.compareTo('null') != 0
                ? RatingBar(
                    onRatingUpdate: null,
                    itemSize: 32,
                    initialRating: double.parse(quotes.rating),
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.green[700],
                    ),
                  )
                : SizedBox()
          ],
        ),
      ));
}
