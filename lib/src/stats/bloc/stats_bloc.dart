import 'dart:async';
import 'dart:ui';

import 'package:ads_repo/ads_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:settings_api/models/local_setting.dart';
import 'package:settings_repo/settings_repo.dart';
import 'package:transactions_api/transactions_api.dart';
import 'package:transactions_repository/transactions_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(
      {required TransactionsRepo transactionsRepo,
      required SettingsRepo settingsRepo,
      required AdsRepo adsRepo})
      : _logger = Logger(),
        _transactionsRepository = transactionsRepo,
        _adsdRepo = adsRepo,
        _settingsRepo = settingsRepo,
        super(StatsState()) {
    on<SubscribeToTransactionsEvent>(_subscribeToTransactions);
    on<IncomeDisplayRequested>(_incomeDisplayRequested);
    on<ExpenseDisplayRequested>(_expenseDisplayRequested);
    on<DatePeriodChosenEvent>(_datePeriodChosen);
    on<SubscribeToCategoriesEvent>(_subscribeToCategories);
    on<SelectedMonthChanged>(_changeSelectedMonth);
    on<SelectedYearChanged>(_changeSelectedYear);
    on<RequestInterstitialEvent>(_requestInterstitial);
    on<IncrementAdCounterEvent>(_incrementAdCounter);
    on<SubscribeToSettingsEvent>(_subscribeToSettings);

    ///Initialization Events
    add(const SubscribeToTransactionsEvent());
    add(SubscribeToCategoriesEvent());
    add(SubscribeToSettingsEvent());
  }

  final TransactionsRepo _transactionsRepository;
  final Logger _logger;
  final AdsRepo _adsdRepo;
  final SettingsRepo _settingsRepo;

  FutureOr<void> _subscribeToTransactions(
    SubscribeToTransactionsEvent event,
    Emitter<StatsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: () => StatsStatus.loading,
      ),
    );
    await emit.forEach<List<LocalTransaction>>(
        _transactionsRepository.transactionStream(), onData: (transactions) {
      ///todo I have to query the transactions that I need here
      final sortedTransactions = _transactionsByDate(
          transactions,
          state.selectedYear,
          state.selectedMonth.month,
          state.datePeriodChosen);
      final sortedCategories =
          _calculateTransactionAmountsPerCategory(sortedTransactions);

      ///todo I have to sort the transactions here, then I have to add up the expense amount totals
      ///to get the percentages
      final (expenseTotals, incomeTotals) =
          _calculateTotalAmounts(sortedTransactions);
      return state.copyWith(
        status: () => StatsStatus.success,
        sortedCategories: () => sortedCategories,
        sortedTransactions: () => sortedTransactions,
        expenseTransactionTotals: () => expenseTotals.toDouble(),
        incomeTransactionTotals: () => incomeTotals.toDouble(),
      );
    });
  }

  ///This method filters transactions by date
  List<LocalTransaction> _transactionsByDate(List<LocalTransaction> transactions,
      int year, int month, DatePeriodChosen dateRange) {
    final transactionsByDate = transactions.where((element) {
      switch (dateRange) {
        case DatePeriodChosen.allTime:
          return true;
        case DatePeriodChosen.monthly:
          return element.dateOfTransaction.month == state.selectedMonth.month &&
              element.dateOfTransaction.year == state.selectedYear;
        case DatePeriodChosen.yearly:
          return element.dateOfTransaction.year == state.selectedYear;
      }
    });
    // _logger.d('transactions by date $transactionsByDate');
    return transactionsByDate.toList();
  }

  ///This method calculates the total amount of all transactions
  List<TransactionCategory> _calculateTransactionAmountsPerCategory(
      List<LocalTransaction> transactions) {
    final pieChartCategories = <TransactionCategory>[];
    for (final transaction in transactions) {
      final category = transaction.category;
      if (category != null) {
        final categoryIndex = pieChartCategories.indexWhere(
          (element) => element.name == category.name,
        );
        if (categoryIndex == -1) {
          pieChartCategories.add(
            TransactionCategory()
              ..iconName = category.iconName
              ..name = category.name
              ..colorName = category.colorName
              ..totalAmount = transaction.amount
              ..totalExpenseAmount =
                  transaction.isExpense ? transaction.amount : 0
              ..totalIncomeAmount =
                  transaction.isIncome ? transaction.amount : 0,
          );
        } else {
          pieChartCategories[categoryIndex].totalAmount += transaction.amount;
          pieChartCategories[categoryIndex].totalExpenseAmount +=
              transaction.isExpense ? transaction.amount : 0;
          pieChartCategories[categoryIndex].totalIncomeAmount +=
              transaction.isIncome ? transaction.amount : 0;
        }
      }
    }
    // _logger.d('list of piechart categories $pieChartCategories');
    return pieChartCategories;
  }

  FutureOr<void> _incomeDisplayRequested(
      IncomeDisplayRequested event, Emitter<StatsState> emit) {
    emit(
      state.copyWith(
        isDisplayIncome: () => true,
        isDisplayExpenses: () => false,
      ),
    );
  }

  FutureOr<void> _expenseDisplayRequested(
      ExpenseDisplayRequested event, Emitter<StatsState> emit) {
    emit(
      state.copyWith(
        isDisplayIncome: () => false,
        isDisplayExpenses: () => true,
      ),
    );
  }

  FutureOr<void> _datePeriodChosen(
      DatePeriodChosenEvent event, Emitter<StatsState> emit) {
    final (expenseTotals, incomeTotals) =
        _calculateTotalAmounts(state.sortedTransactions);
    switch (event.datePeriodChosen) {
      case DatePeriodChosen.allTime:
        emit(
          state.copyWith(
            datePeriodChosen: () => DatePeriodChosen.allTime,
            expenseTransactionTotals: () => expenseTotals,
            incomeTransactionTotals: () => incomeTotals,
          ),
        );
        break;
      case DatePeriodChosen.monthly:
        emit(
          state.copyWith(
            datePeriodChosen: () => DatePeriodChosen.monthly,
            selectedMonth: () => dateLabelMapper[DateTime.now().month]!,
            expenseTransactionTotals: () => expenseTotals,
            incomeTransactionTotals: () => incomeTotals,
          ),
        );
        break;
      case DatePeriodChosen.yearly:
        emit(
          state.copyWith(
            datePeriodChosen: () => DatePeriodChosen.yearly,
            expenseTransactionTotals: () => expenseTotals,
            incomeTransactionTotals: () => incomeTotals,
          ),
        );
        break;
    }
  }

  FutureOr<void> _subscribeToCategories(
      SubscribeToCategoriesEvent event, Emitter<StatsState> emit) async {
    await emit.forEach<List<StoredCategory>>(
      _transactionsRepository.sortedCategoryStream(),
      onData: (categories) {
        final sortedCategories =
            _calculateTransactionAmountsPerCategory(state.transactions);
        // _logger.d('These are the sorted categories: $categories');
        return state.copyWith(
          status: () => StatsStatus.success,
          sortedCategories: () => sortedCategories,
        );
      },
      onError: (_, __) => state.copyWith(status: () => StatsStatus.failure),
    );
  }

  (double, double) _calculateTotalAmounts(List<LocalTransaction> transactions) {
    var expenseTotal = 0.0;
    var incomeTotal = 0.0;
    for (final transaction in transactions) {
      if (transaction.isExpense) {
        expenseTotal += transaction.amount;
      }
      if (transaction.isIncome) {
        incomeTotal += transaction.amount;
      }
    }
    return (expenseTotal, incomeTotal);
  }

  FutureOr<void> _changeSelectedMonth(
      SelectedMonthChanged event, Emitter<StatsState> emit) async {
    final (expenseTotals, incomeTotals) =
        await _calculateTotalAmounts(state.sortedTransactions);
    _logger.f(
        'these are the expense totals for ${state.selectedMonth}: $expenseTotals and icometotals:for ${state.selectedMonth}:    $incomeTotals');
    emit(
      state.copyWith(
        status: () => StatsStatus.success,
        selectedMonth: () => event.selectedMonth,
        incomeTransactionTotals: () => incomeTotals,
        expenseTransactionTotals: () => expenseTotals,
      ),
    );
    _logger.d('This is the  month that was sent ${event.selectedMonth}');
    _logger.d('This is the month that was selected ${state.selectedMonth}');
  }

  FutureOr<void> _changeSelectedYear(
      SelectedYearChanged event, Emitter<StatsState> emit) {
    final (expenseTotals, incomeTotals) =
        _calculateTotalAmounts(state.sortedTransactions);
    emit(
      state.copyWith(
        status: () => StatsStatus.success,
        selectedYear: () => event.selectedYear,
        incomeTransactionTotals: () => incomeTotals,
        expenseTransactionTotals: () => expenseTotals,
      ),
    );
  }

  FutureOr<void> _incrementAdCounter(event, Emitter<StatsState> emit) async {
    await _settingsRepo.incrementAdCounter();
    _logger.f(
        'This is the settings object from the Db: ${state.localSetting} \n and this is its adcount${state.localSetting?.adCounterNumber}');
  }

  FutureOr<void> _requestInterstitial(
      RequestInterstitialEvent event, Emitter<StatsState> emit) async {
    _adsdRepo.getInterstitialAd(
        onAdDismissedFullScreenContent: event.onAdDismissedFullScreenContent);
  }

  FutureOr<void> _subscribeToSettings(
      SubscribeToSettingsEvent event, Emitter<StatsState> emit) async {
    await emit.forEach(
      _settingsRepo.settingsStream(),
      onData: (setting) => state.copyWith(
        localSetting: () => setting,
        status: () => StatsStatus.success,
      ),
    );
  }
}
