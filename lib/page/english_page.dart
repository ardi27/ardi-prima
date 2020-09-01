import 'package:ardi_prima/bloc/quotes_bloc.dart';
import 'package:ardi_prima/model/quotes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EnglishPage extends StatefulWidget {
  EnglishPage({Key key}) : super(key: key);

  @override
  _EnglishPageState createState() => _EnglishPageState();
}

class _EnglishPageState extends State<EnglishPage> {
  final _scrollController = ScrollController();
  final _scrollTreshold = 200;
  QuotesBloc _quotesBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _quotesBloc = BlocProvider.of<QuotesBloc>(context);
    _quotesBloc.add(FetchQuotes());
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

    if (maxScroll - currentScroll <= _scrollTreshold) {
      _quotesBloc.add(FetchQuotes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("English Quotes")),
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
                return buildErrorUi(state.message);
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
  return Center(
    child: CircularProgressIndicator(),
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
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Row(
          children: [
            Icon(
              Icons.person,
              size: 20,
            ),
            Text(
              quotes.author,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        subtitle: Text(
          quotes.en,
          style: TextStyle(fontSize: 20),
        ),
      ));
}

Widget buildErrorUi(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    ),
  );
}
