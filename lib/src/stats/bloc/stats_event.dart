part of 'stats_bloc.dart';

final class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

final class StatsInitialEvent extends StatsEvent {
  const StatsInitialEvent();

  @override
  List<Object?> get props => [];
}

final class PieChartSectionEvent extends StatsEvent {
  const PieChartSectionEvent();

  @override
  List<Object?> get props => [];
}

final class SubscribeToTransactionsEvent extends StatsEvent {
  const SubscribeToTransactionsEvent();

  @override
  List<Object?> get props => [];
}

final class CalculateTransactionsForChosenDates extends StatsEvent {
  const CalculateTransactionsForChosenDates();

  @override
  List<Object?> get props => [];
}

final class LoadedCategoryAmountsEvent extends StatsEvent {
  const LoadedCategoryAmountsEvent();

  @override
  List<Object?> get props => [];
}

final class SetTransactionCategoryType extends StatsEvent {
  const SetTransactionCategoryType();

  @override
  List<Object?> get props => [];
}

final class IncomeDisplayRequested extends StatsEvent {
  const IncomeDisplayRequested();

  @override
  List<Object?> get props => [];
}

final class ExpenseDisplayRequested extends StatsEvent {
  const ExpenseDisplayRequested();

  @override
  List<Object?> get props => [];
}

final class DatePeriodChosenEvent extends StatsEvent {
  const DatePeriodChosenEvent(this.datePeriodChosen);

  final DatePeriodChosen datePeriodChosen;

  @override
  List<Object?> get props => [datePeriodChosen];
}

final class SubscribeToCategoriesEvent extends StatsEvent {
  const SubscribeToCategoriesEvent();

  @override
  List<Object?> get props => [];
}

final class SelectedMonthChanged extends StatsEvent {
  const SelectedMonthChanged(this.selectedMonth);

  final DateLabel selectedMonth;

  @override
  List<Object?> get props => [selectedMonth];
}

final class SelectedYearChanged extends StatsEvent {
  const SelectedYearChanged(this.selectedYear);

  final int selectedYear;

  @override
  List<Object?> get props => [selectedYear];
}

final class RequestInterstitialEvent extends StatsEvent {
  const RequestInterstitialEvent({
    required this.onAdDismissedFullScreenContent,
  });

  final VoidCallback onAdDismissedFullScreenContent;

  @override
  List<Object> get props => [onAdDismissedFullScreenContent];
}

final class IncrementAdCounterEvent extends StatsEvent {
  const IncrementAdCounterEvent({
    required this.onAdDismissedFullScreenContent,
  });

  final VoidCallback onAdDismissedFullScreenContent;

  @override
  List<Object> get props => [onAdDismissedFullScreenContent];
}

final class SubscribeToSettingsEvent extends StatsEvent {
  @override
  List<Object> get props => [];
}
