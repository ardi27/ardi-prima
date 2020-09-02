import 'dart:async';

import 'package:ardi_prima/model/quotes.dart';
import 'package:ardi_prima/repository/quotes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'quotes_event.dart';
part 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesRepository quotesRepository;
  QuotesBloc({@required this.quotesRepository}) : super(QuotesInitial());

  @override
  Stream<QuotesState> mapEventToState(
    QuotesEvent event,
  ) async* {
    if (event is FetchQuotes && !_hasReachedMax(state)) {
      final currentState = state;
      try {
        if (currentState is QuotesInitial) {
          List<Quotes> quotes = await quotesRepository.fetchQuotes(1);
          yield QuotesLoaded(
              quotes: quotes, hasReachedMax: false, currentPage: 1);
          return;
        } else if (currentState is QuotesLoaded) {
          List<Quotes> quotes =
              await quotesRepository.fetchQuotes(currentState.currentPage + 1);
          yield quotes.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : QuotesLoaded(
                  quotes: currentState.quotes + quotes,
                  hasReachedMax: false,
                  currentPage: currentState.currentPage + 1);
        } else if (currentState is QuotesError) {
          List<Quotes> quotes = await quotesRepository.fetchQuotes(1);
          yield QuotesLoaded(
              quotes: quotes, hasReachedMax: false, currentPage: 1);
          return;
        }
      } catch (e) {
        yield QuotesError(message: "An error occured");
      }
    }
  }

  bool _hasReachedMax(QuotesState state) =>
      state is QuotesLoaded && state.hasReachedMax;
}
