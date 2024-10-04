part of 'edit_transaction_bloc.dart';

enum EditTransactionStatus { initial, loading, success, failure }

final class EditTransactionState extends Equatable {
  EditTransactionState({
    this.status = EditTransactionStatus.success,
    required this.transaction,
    this.isCategorySelected = false,
    this.isCategoryExpanded = false,
    this.categories = const [],
    this.amountDisplayError =false,
    tempDate,
  }) : tempDate = transaction.dateOfTransaction;

  final EditTransactionStatus status;
  final LocalTransaction transaction;
  final bool isCategorySelected;
  final bool isCategoryExpanded;
  final List<StoredCategory> categories;
  final DateTime tempDate;
  final bool amountDisplayError;

  @override
  // TODO: implement props
  List<Object?> get props => [
        status,
        transaction,
        categories,
        tempDate,
        isCategoryExpanded,
        isCategorySelected,
        amountDisplayError,
      ];

  EditTransactionState copyWith(
      {EditTransactionStatus Function()? status,
      LocalTransaction Function()? transaction,
      bool Function()? isCategorySelected,
      bool Function()? isCategoryExpanded,
      List<StoredCategory> Function()? categories,
      DateTime Function()? tempDate,
      bool Function()? amountDisplayError,
      TransactionCategory Function()? tempCategory}) {
    // categories: categories != null ? categories() : this.categories,
    return EditTransactionState(
      status: status != null ? status() : this.status,
      transaction: transaction != null ? transaction() : this.transaction,
      isCategorySelected: isCategorySelected != null
          ? isCategorySelected()
          : this.isCategorySelected,
      isCategoryExpanded: isCategoryExpanded != null
          ? isCategoryExpanded()
          : this.isCategoryExpanded,
      categories: categories != null ? categories() : this.categories,
      tempDate: tempDate != null ? tempDate() : this.tempDate,
      amountDisplayError: amountDisplayError != null
          ? amountDisplayError()
          : this.amountDisplayError,
    );
  }
}
