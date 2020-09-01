part of 'quotes_bloc.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object> get props => [];
}

class QuotesInitial extends QuotesState {}

class QuotesLoaded extends QuotesState {
  final List<Quotes> quotes;
  final bool hasReachedMax;
  final int currentPage;
  QuotesLoaded(
      {@required this.quotes,
      @required this.hasReachedMax,
      @required this.currentPage});
  QuotesLoaded copyWith(
      {List<Quotes> quotes, bool hasReachedMax, int currentPage}) {
    return QuotesLoaded(
        quotes: quotes ?? this.quotes,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object> get props => [quotes, hasReachedMax, currentPage];
}

class QuotesLoading extends QuotesState {}

class QuotesError extends QuotesState {
  final String message;
  QuotesError({@required this.message});
  @override
  List<Object> get props => [message];
}
