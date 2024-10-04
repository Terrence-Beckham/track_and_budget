import 'package:ads_repo/ads_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:razor_expense_tracker_new/src/ads/ads.dart';
import 'package:razor_expense_tracker_new/src/stats/bloc/stats_bloc.dart';
import 'package:settings_repo/settings_repo.dart';
import 'package:transactions_repository/transactions_repository.dart';

import '../../widgets/konstants.dart';

class StatsOverviewPage extends StatelessWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StatsBloc(
            settingsRepo: context.read<SettingsRepo>(),
            adsRepo: context.read<AdsRepo>(),
            transactionsRepo: context.read<TransactionsRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => AdsBloc(
            adsRepo: context.read<AdsRepo>(),
          ),
        ),
      ],
      child: StatsView(),
    );

    // );
  }
}

class emptyStatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr('noDataToDisplay'),
      ),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            switch (state.status) {
              case StatsStatus.success:
                return StatsSuccessView();

              case StatsStatus.loading:
                return const Center(
                  child: Text('Loading'),
                );
              case StatsStatus.initial:
                return const Center(
                  child: Text('Initial'),
                );

              case StatsStatus.failure:
                return Center(
                  child: emptyStatsView(),
                );
            }
          },
        ),
      ),
    );
  }
}

class StatsSuccessView extends StatelessWidget {
  StatsSuccessView({super.key}) : _logger = Logger();
  final Logger _logger;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (previous, current) =>
              previous.datePeriodChosen != current.datePeriodChosen,
          listener: (context, state) {
            context.read<StatsBloc>()..add(SubscribeToTransactionsEvent());
          },
        ),
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (previous, current) =>
              previous.selectedMonth != current.selectedMonth,
          listener: (context, state) {
            context.read<StatsBloc>()..add(SubscribeToTransactionsEvent());
          },
        ),
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (previous, current) =>
              previous.selectedYear != current.selectedYear,
          listener: (context, state) {
            context.read<StatsBloc>()..add(SubscribeToTransactionsEvent());
          },
        ),
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (previous, current) =>
              previous.incomeTransactionTotals !=
              current.incomeTransactionTotals,
          listener: (context, state) {
            context.read<StatsBloc>()..add(SubscribeToTransactionsEvent());
          },
        ),
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (previous, current) =>
              previous.expenseTransactionTotals !=
              current.expenseTransactionTotals,
          listener: (context, state) {
            context.read<StatsBloc>()..add(SubscribeToTransactionsEvent());
          },
        ),
      ],
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          final locale = context.locale;
          _logger.d(
              ' These are the expenseTransactionTotals: ${state.expenseTransactionTotals}');
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.tr('analytics'),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: state.isDisplayExpenses
                          ? OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.grey,
                                // Border color when button is not pressed
                                width:
                                    4, // Border width when button is not pressed
                              ),
                            )
                          :

                          ///Button to change the transaction type to Income
                          OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.white,
                                // Border color when button is not pressed
                                width:
                                    4, // Border width when button is not pressed
                              ),
                            ),
                      onPressed: () {
                        context.read<StatsBloc>()
                          ..add(ExpenseDisplayRequested())
                          ..add(
                            IncrementAdCounterEvent(
                              onAdDismissedFullScreenContent: () {},
                            ),
                          );
                      },
                      child: Text(
                        context.tr('expenses'),
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    OutlinedButton(
                      style: state.isDisplayIncome
                          ? OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.grey,
                                // Border color when button is not pressed
                                width:
                                    4, // Border width when button is not pressed
                              ),
                            )
                          :

                          ///Button to change the transaction type to Income
                          OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.white,
                                // Border color when button is not pressed
                                width:
                                    4, // Border width when button is not pressed
                              ),
                            ),
                      onPressed: () {
                        context.read<StatsBloc>()
                          ..add(IncomeDisplayRequested())
                          ..add(IncrementAdCounterEvent(
                            onAdDismissedFullScreenContent: () {},
                          ));
                      },
                      child: Text(
                        context.tr("income"),
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputChip(
                        elevation: 6,
                        label: Text(
                          context.tr('allTime'),
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          context.read<StatsBloc>()
                            ..add(
                                DatePeriodChosenEvent(DatePeriodChosen.allTime))
                            ..add(
                              IncrementAdCounterEvent(
                                onAdDismissedFullScreenContent: () {},
                              ),
                            );
                        },
                        selectedColor: Colors.green,
                        selected:
                            state.datePeriodChosen == DatePeriodChosen.allTime,
                      ),
                      InputChip(
                        elevation: 6,
                        label: Text(context.tr('yearly'),
                            style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          context.read<StatsBloc>()
                            ..add(
                                DatePeriodChosenEvent(DatePeriodChosen.yearly))
                            ..add(
                              IncrementAdCounterEvent(
                                onAdDismissedFullScreenContent: () {},
                              ),
                            );
                        },
                        selectedColor: Colors.yellow,
                        selected:
                            state.datePeriodChosen == DatePeriodChosen.yearly,
                      ),
                      InputChip(
                        elevation: 6,
                        label: Text(context.tr('monthly'),
                            style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          context.read<StatsBloc>()
                            ..add(
                                DatePeriodChosenEvent(DatePeriodChosen.monthly))
                            ..add(
                              IncrementAdCounterEvent(
                                onAdDismissedFullScreenContent: () {},
                              ),
                            );
                        },
                        selectedColor: Colors.red,
                        selected:
                            state.datePeriodChosen == DatePeriodChosen.monthly,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                      ),
                      if (state.datePeriodChosen ==
                          DatePeriodChosen.yearly) ...[
                        YearDropdownMenu()
                      ] else if (state.datePeriodChosen ==
                          DatePeriodChosen.monthly) ...[
                        YearDropdownMenu(),
                        const SizedBox(width: 25),
                        DateDropdownMenu()
                      ]
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 1.8,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.isDisplayExpenses &&
                          state.expenseTransactionTotals > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('expenses'),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              translateDigits(
                                  state.expenseTransactionTotals
                                      .toStringAsFixed(1),
                                  locale),
                              // state.expenseTransactionTotals.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      if (state.isDisplayIncome &&
                          state.incomeTransactionTotals > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('income'),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              translateDigits(
                                  state.incomeTransactionTotals
                                      .toStringAsFixed(1),
                                  locale),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      if (state.sortedCategories.isNotEmpty)
                        PieChart(
                          PieChartData(
                            titleSunbeamLayout: true,
                            sections: List.generate(
                              state.sortedCategories.length,
                              (index) {
                                return PieChartSectionData(
                                    radius: 50,
                                    color: colorMapper[state
                                        .sortedCategories[index].colorName],
                                    titleStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    value: state.isDisplayExpenses
                                        ? state.sortedCategories[index]
                                            .totalExpenseAmount
                                            .toDouble()
                                        : state.sortedCategories[index]
                                            .totalIncomeAmount
                                            .toDouble());
                                // title: state.isDisplayExpenses
                                //     // ? '${state.sortedCategories[index].name}\n'
                                //     ? '\$${state.sortedCategories[index].totalExpenseAmount}'
                                //     // : '${state.sortedCategories[index].name}\n'
                                //     : '\$${state.sortedCategories[index].totalIncomeAmount}');
                              },
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            context.tr('noDataToDisplay'),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 30,
                // ),
                // Divider(
                //   color: Colors.grey,
                //   thickness: 6,
                // ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: state.sortedCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (state.isDisplayExpenses &&
                            state.sortedCategories[index].totalExpenseAmount >
                                0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(8, 8),
                                      blurRadius: 15,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-8, -8),
                                      blurRadius: 15,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(8, 8),
                                          blurRadius: 15,
                                          spreadRadius: 1),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-8, -8),
                                          blurRadius: 15,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  //Center(
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               shape: BoxShape.circle,
                                  //               border: Border.all(color: Colors.grey, width: 2.0),
                                  //             ),
                                  //             child: ClipOval(
                                  //               child: CircleAvatar(
                                  //                 radius: 50,
                                  //                 backgroundImage: NetworkImage(
                                  //                   'https://via.placeholder.com/150',
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),

                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.grey[50],
                                        child: Icon(
                                          myIcons[state.sortedCategories[index]
                                              .iconName],
                                          color: colorMapper[state
                                              .sortedCategories[index]
                                              .colorName],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  context.tr(
                                          '${state.sortedCategories[index].name?.toLowerCase()}') ??
                                      ' ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: locale.languageCode == 'ar'
                                    ? Text(
                                        ' ' +
                                            translateDigits(
                                                state.sortedCategories[index]
                                                    .totalExpenseAmount
                                                    .toString(),
                                                locale) +
                                            ' ' +
                                            '£',
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : Text(
                                        '\$' +
                                            ' ' +
                                            translateDigits(
                                                state.sortedCategories[index]
                                                    .totalExpenseAmount
                                                    .toString(),
                                                locale),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                trailing: Text(
                                  translateDigits(
                                      ' ${((state.sortedCategories[index].totalExpenseAmount) / state.expenseTransactionTotals * 100).toPrecision(1)} %',
                                      locale),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (state.isDisplayIncome &&
                            state.sortedCategories[index].totalIncomeAmount >
                                0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(8, 8),
                                      blurRadius: 15,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-8, -8),
                                      blurRadius: 15,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(8, 8),
                                          blurRadius: 15,
                                          spreadRadius: 1),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-8, -8),
                                          blurRadius: 15,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[50],
                                    child: Icon(
                                      myIcons[state
                                          .sortedCategories[index].iconName],
                                      color: colorMapper[state
                                          .sortedCategories[index].colorName],
                                    ),
                                  ),
                                ),
                                title: Text(
                                  context.tr(
                                          '${state.sortedCategories[index].name?.toLowerCase()}') ??
                                      ' ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: locale.languageCode == 'ar'
                                    ? Text(
                                        '£' +
                                            ' ' +
                                            translateDigits(
                                                state.sortedCategories[index]
                                                    .totalIncomeAmount
                                                    .toString(),
                                                locale),
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : Text(
                                        '\$' +
                                            ' ' +
                                            translateDigits(
                                                state.sortedCategories[index]
                                                    .totalIncomeAmount
                                                    .toString(),
                                                locale),
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                trailing: Text(
                                  // '\$ ${state.sortedCategories[index].incomePercentage}',

                                  translateDigits(
                                      ' ${((state.sortedCategories[index].totalIncomeAmount) / state.incomeTransactionTotals * 100).toPrecision(1)} %',
                                      locale),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                        ;
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

//colorMapper = <String, Color>{
//   'red': Colors.red,
//   'yellow': Colors.yellow,
//   'blue': Colors.blue,
//   'white': Colors.white,
class DateDropdownMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: DropdownButton<DateLabel>(
            value: state.selectedMonth, // Set the initial selection
            onChanged: (DateLabel? newValue) {
              // Handle the selected value here
              context.read<StatsBloc>().add(SelectedMonthChanged(newValue!));
            },
            items: DateLabel.values
                .map<DropdownMenuItem<DateLabel>>((DateLabel dateLabel) {
              return DropdownMenuItem<DateLabel>(
                value: dateLabel,
                child: Text(
                  context.tr('${dateLabel.name}'),
                  style: TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class YearDropdownMenu extends StatelessWidget {
  final List<int> years =
      List<int>.generate(10, (int index) => (DateTime.now().year - 2) + index);

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: DropdownButton<int>(
            hint: Text('Select a year'),
            value: state.selectedYear,
            onChanged: (int? newValue) {
              context.read<StatsBloc>().add(SelectedYearChanged(newValue!));
              // if (newValue != null) {
              //   context.read<StatsBloc>().add(YearSelected(newValue));
              // }
            },
            items: years.map<DropdownMenuItem<int>>((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(
                  translateDigits(year.toString(), locale),
                  style: TextStyle(fontSize: 20),
                ),
                // child: Text(year.toString()),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class NeomorphicContainer extends StatelessWidget {
  final Widget child;

  const NeomorphicContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(8, 8),
              blurRadius: 15,
              spreadRadius: 1),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-8, -8),
              blurRadius: 15,
              spreadRadius: 1)
        ],
      ),
    );
  }
}
