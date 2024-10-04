part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

enum DatePeriodChosen { allTime, yearly, monthly }

// DropdownMenuEntry labels and values for the first dropdown menu.
enum DateLabel {
  january('January', 1),
  february('Febuary', 2),
  march('March', 3),
  april('April', 4),
  may('May', 5),
  june('June', 6),
  july('July', 7),
  august('August', 8),
  september('September', 9),
  october('October', 10),
  november('November', 11),
  december('December', 12);

  const DateLabel(this.label, this.month);

  final String label;
  final int month;
}

final dateLabelMapper = <int, DateLabel>{
  1: DateLabel.january,
  2: DateLabel.february,
  3: DateLabel.march,
  4: DateLabel.april,
  5: DateLabel.may,
  6: DateLabel.june,
  7: DateLabel.july,
  8: DateLabel.august,
  9: DateLabel.september,
  10: DateLabel.october,
  11: DateLabel.november,
  12: DateLabel.december,
};

// The currently selected year

final class StatsState extends Equatable {
  StatsState({
    this.status = StatsStatus.initial,
    this.transactions = const [],
    this.sortedTransactions = const [],
    this.expenseTransactionTotals = 0,
    this.incomeTransactionTotals = 0,
    this.categories = const [],
    this.sortedCategories = const [],
    this.totalAmount = 0,
    this.isDisplayExpenses = true,
    this.isDisplayIncome = false,
    this.datePeriodChosen = DatePeriodChosen.allTime,
    this.expenseTransactions = const [],
    this.incomeTransactions = const [],
    this.selectedMonth = DateLabel.june,
    this.selectedYear = 2024,
    this.localSetting = null,
  });

  //    int? selectedYear,
  //   }) : selectedYear = selectedYear ?? DateTime.now().year;
  // this.selectedMonth = dateLabelMapper[DateTime.now().month]!,
  ///This is the raw list of transactions from the database
  final List<LocalTransaction> transactions;

  ///This is a list of Transactions that had been filtered by date
  final List<LocalTransaction> sortedTransactions;

  ///This is a list of categories after the transactions have been sorted and the amounts calculated
  final List<TransactionCategory> sortedCategories;

  ///This is the status of the stats state
  final StatsStatus status;

  ///This is the list of all transaction categories
  final List<TransactionCategory> categories;

  /// Set to true if the user wants to display expenses
  final bool isDisplayExpenses;

  /// Set to true if the user wants to display income
  final bool isDisplayIncome;

  /// The date period chosen by the user
  final DatePeriodChosen datePeriodChosen;

  /// The list of transactions that are expenses
  final expenseTransactions;

  /// The list of transactions that are income
  final incomeTransactions;

  /// The selected month for the stats
  final DateLabel selectedMonth;

  /// The selected year for the stats
  final selectedYear;

  /// The total amount of all transactions
  final int totalAmount;

  ///This is the calculate total of all of the current expense transaction amounts
  final double expenseTransactionTotals;

  ///This is the calculate total of all of the current income transaction amounts
  final double incomeTransactionTotals;

  final LocalSetting? localSetting;


  StatsState copyWith({
    List<LocalTransaction> Function()? transactions,
    StatsStatus Function()? status,
    List<TransactionCategory> Function()? categories,
    List<LocalTransaction> Function()? sortedTransactions,
    List<TransactionCategory> Function()? sortedCategories,
    List<LocalTransaction> Function()? expenseTransactions,
    List<LocalTransaction> Function()? incomeTransactions,
    bool Function()? showTransactions,
    int Function()? totalAmount,
    bool Function()? isDisplayExpenses,
    bool Function()? isDisplayIncome,
    DatePeriodChosen Function()? datePeriodChosen,
    DateLabel Function()? selectedMonth,
    int Function()? selectedYear,
    double Function()? expenseTransactionTotals,
    double Function()? incomeTransactionTotals,

    LocalSetting? Function()? localSetting,
  }) {
    return StatsState(
        categories: categories != null ? categories() : this.categories,
        transactions: transactions != null ? transactions() : this.transactions,
        expenseTransactionTotals: expenseTransactionTotals != null
            ? expenseTransactionTotals()
            : this.expenseTransactionTotals,
        incomeTransactionTotals: incomeTransactionTotals != null
            ? incomeTransactionTotals()
            : this.incomeTransactionTotals,
        sortedCategories:
        sortedCategories != null ? sortedCategories() : this.sortedCategories,
        status: status != null ? status() : this.status,
        totalAmount: totalAmount != null ? totalAmount() : this.totalAmount,
        isDisplayExpenses: isDisplayExpenses != null
            ? isDisplayExpenses()
            : this.isDisplayExpenses,
        isDisplayIncome:
        isDisplayIncome != null ? isDisplayIncome() : this.isDisplayIncome,
        datePeriodChosen:
        datePeriodChosen != null ? datePeriodChosen() : this.datePeriodChosen,
        expenseTransactions: expenseTransactions != null
            ? expenseTransactions()
            : this.expenseTransactions,
        incomeTransactions: incomeTransactions != null
            ? incomeTransactions()
            : this.incomeTransactions,
        selectedMonth:
        selectedMonth != null ? selectedMonth() : this.selectedMonth,
        selectedYear: selectedYear != null ? selectedYear() : this.selectedYear,
        sortedTransactions: sortedTransactions != null
            ? sortedTransactions()
            : this.sortedTransactions,
        localSetting:
        localSetting != null ? localSetting() : this.localSetting);

  }

  @override
  List<Object?> get props =>
      [
        transactions,
        incomeTransactionTotals,
        expenseTransactionTotals,
        sortedTransactions,
        sortedCategories,
        status,
        categories,
        isDisplayExpenses,
        isDisplayIncome,
        datePeriodChosen,
        expenseTransactions,
        incomeTransactions,
        selectedMonth,
        selectedYear,
        totalAmount,
        localSetting,
      ];
}
