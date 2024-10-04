part of 'transactions_overview_bloc.dart';

enum TransactionsOverviewStatus { initial, loading, success, failure }

final class TransactionsOverviewState extends Equatable {
  const TransactionsOverviewState({
    this.status = TransactionsOverviewStatus.success,
    this.transactions = const [],
    this.incomeTotals = 0,
    this.expenseTotals = 0,
    this.balance = 0,
    this.deletedTransaction,
    this.localSetting = null,
  });

  final TransactionsOverviewStatus status;
  final List<LocalTransaction> transactions;
  final int incomeTotals;
  final int expenseTotals;
  final int balance;
  final LocalTransaction? deletedTransaction;
  final LocalSetting? localSetting;

  TransactionsOverviewState copyWith({
    TransactionsOverviewStatus Function()? status,
    List<LocalTransaction> Function()? transactions,
    int Function()? incomeTotals,
    int Function()? expenseTotals,
    int Function()? balance,
    LocalTransaction? Function()? deletedTransaction,
    LocalSetting? Function()? localSetting,
  }) {
    return TransactionsOverviewState(
        status: status != null ? status() : this.status,
        transactions: transactions != null ? transactions() : this.transactions,
        incomeTotals: incomeTotals != null ? incomeTotals() : this.incomeTotals,
        expenseTotals:
            expenseTotals != null ? expenseTotals() : this.expenseTotals,
        balance: balance != null ? balance() : this.balance,
        deletedTransaction: deletedTransaction != null
            ? deletedTransaction()
            : this.deletedTransaction,
        localSetting:
            localSetting != null ? localSetting() : this.localSetting);
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        incomeTotals,
        expenseTotals,
        balance,
        deletedTransaction,
        localSetting,
      ];
}
