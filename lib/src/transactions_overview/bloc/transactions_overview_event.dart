part of 'transactions_overview_bloc.dart';

abstract class TransactionsOverviewEvent extends Equatable {
  const TransactionsOverviewEvent();
}

final class InitialDataEvent extends TransactionsOverviewEvent {
  const InitialDataEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteTransactionEvent extends TransactionsOverviewEvent {
  const DeleteTransactionEvent(this.transaction);

  final LocalTransaction transaction;

  @override
  List<Object?> get props => [transaction];
}

final class UndoDeleteTransactionEvent extends TransactionsOverviewEvent {
  const UndoDeleteTransactionEvent(this.transaction);

  final LocalTransaction transaction;

  @override
  List<Object?> get props => [transaction];
}

final class TransactionsRequestedEvent extends TransactionsOverviewEvent {
  const TransactionsRequestedEvent();

  @override
  List<Object?> get props => [];
}

final class GetSettingsEvent extends TransactionsOverviewEvent {
  @override
  List<Object?> get props => [];
}

final class IncrementAdCounterEvent extends TransactionsOverviewEvent {
  @override
  List<Object?> get props => [];
}

class RequestInterstitialEvent extends TransactionsOverviewEvent {
  const RequestInterstitialEvent({
    required this.onAdDismissedFullScreenContent,
  });

  final VoidCallback onAdDismissedFullScreenContent;

  @override
  List<Object> get props => [onAdDismissedFullScreenContent];
}
