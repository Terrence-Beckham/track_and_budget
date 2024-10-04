import 'package:ads_repo/ads_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:razor_expense_tracker_new/src/ads/ads.dart';
import 'package:settings_repo/settings_repo.dart';
import 'package:transactions_repository/transactions_repository.dart';

import '../../edit_transaction/view/edit_transaction_view.dart';
import '../../widgets/konstants.dart';
import '../bloc/transactions_overview_bloc.dart';

class TransactionsOverviewPage extends StatelessWidget {
  const TransactionsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsOverviewBloc(
              context.read<TransactionsRepo>(),
              context.read<SettingsRepo>(),
              context.read<AdsRepo>()),
        ),
        BlocProvider(
          create: (context) => AdsBloc(
            adsRepo: context.read<AdsRepo>(),
          ),
        ),
      ],
      child: const TransactionsOverviewView(),
    );
  }
}

class TransactionsOverviewView extends StatelessWidget {
  const TransactionsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Razor Expense & Budget Tracker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<TransactionsOverviewBloc, TransactionsOverviewState>(
          builder: (context, state) {
            switch (state.status) {
              case TransactionsOverviewStatus.initial:
                return const Center(child: Text('Initial View'));
              case TransactionsOverviewStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case TransactionsOverviewStatus.success:
                return const ExpenseOverviewSuccessView();
              case TransactionsOverviewStatus.failure:
                return Center(
                  child: Text(
                    context.tr('somethingWentWrong'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class ExpenseOverviewSuccessView extends StatelessWidget {
  const ExpenseOverviewSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsOverviewBloc, TransactionsOverviewState>(
      listenWhen: (previous, current) =>
          previous.deletedTransaction != current.deletedTransaction &&
              current.deletedTransaction != null ||
          (previous.localSetting?.adCounterNumber !=
              current.localSetting?.adCounterNumber),
      listener: (context, state) {
        if (state.deletedTransaction != null) {
          final deletedTransaction = state.deletedTransaction;
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                context.tr('transactionDeleted'),
                style: GoogleFonts.comicNeue(
                    textStyle: TextStyle(fontSize: 24),
                    fontWeight: FontWeight.bold),
              ),
              action: SnackBarAction(
                label: context.tr('undo'),
                onPressed: () {
                  // Use the correct context to access the provider
                  context.read<TransactionsOverviewBloc>().add(
                        UndoDeleteTransactionEvent(deletedTransaction!),
                      );
                },
              ),
            ),
          );
        }
        if (state.localSetting!.adCounterNumber >=
            state.localSetting!.adCounterThreshold) {
          context.read<TransactionsOverviewBloc>().add(
                RequestInterstitialEvent(
                  onAdDismissedFullScreenContent: () => {},
                ),
              );
        }
      },
      builder: (context, state) {
        final locale = context.locale;
        return Column(
          children: [
            Container(
              child: ListTile(
                title: Text(
                  context.tr('helloUser'),
                  style: TextStyle(fontSize: 18),
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
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
                    backgroundColor: Colors.grey[50],
                    child: Icon(
                      Iconsax.user_square,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
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
                          spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          context.tr('totalBalance'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (state.transactions.isNotEmpty)
                        Text(
                          locale.languageCode == 'en'
                              ? r'$ ' +
                                  translateDigits(
                                      state.balance.toString(), locale) +
                                  ' '
                              : translateDigits(
                                      state.balance.toString(), locale) +
                                  ' ' +
                                  r'£',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 34,
                          ),
                        )
                      else
                        const Text(r'$'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(4, 4),
                                          blurRadius: 15,
                                          spreadRadius: 1),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4, -4),
                                          blurRadius: 15,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: Icon(
                                    Iconsax.arrow_up_3,
                                    // Icons.arrow_upward_rounded,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      context.tr('income'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Text(
                                      locale.languageCode == 'en'
                                          ? translateDigits(
                                                  r'$ ' +
                                                      state.incomeTotals
                                                          .toString(),
                                                  locale) +
                                              ' '
                                          : translateDigits(
                                                  state.incomeTotals.toString(),
                                                  locale) +
                                              ' ' +
                                              r'£',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),SizedBox(width: 50,),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(4, 4),
                                        blurRadius: 15,
                                        spreadRadius: 1),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-4, -4),
                                        blurRadius: 15,
                                        spreadRadius: 1)
                                  ],
                                ),
                                child: Icon(
                                  Iconsax.arrow_down,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      context.tr('expenses'),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      locale.languageCode == 'en'
                                          ? translateDigits(
                                                  r'$ ' +
                                                      state.expenseTotals
                                                          .toString(),
                                                  locale) +
                                              ' '
                                          : translateDigits(
                                                  state.expenseTotals
                                                      .toString(),
                                                  locale) +
                                              ' ' +
                                              r'£',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('transactions'),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     context.read<AdsBloc>().add(
            //       InterstitialAdRequestedEvent(
            //         onAdDismissedFullScreenContent: () {
            //           context.read().add(
            //                 InterstitialAdDisposed(),
            //               ); // Handle ad dismissal here
            //         },
            //       ),
            //     );
            //   },
            //   child: Icon(Icons.dangerous),
            // ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 50,
                child: ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (BuildContext context, int index) {
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
                        height: 75,
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  context.read<TransactionsOverviewBloc>().add(
                                      DeleteTransactionEvent(
                                          state.transactions[index]));
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                              ),

                              ///Edit Button
                              SlidableAction(
                                onPressed: (context) {
                                  context
                                      .read<TransactionsOverviewBloc>()
                                      .add(IncrementAdCounterEvent());
                                  Navigator.of(context).push(
                                    MaterialPageRoute<EditTransactionPage>(
                                      builder: (context) => EditTransactionPage(
                                        transaction: state.transactions[index],
                                      ),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.green,
                                icon: Icons.edit,
                              ),
                            ],
                          ),
                          child: Container(
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
                                    myIcons[state.transactions[index].category
                                        ?.iconName],
                                    color: colorMapper[state.transactions[index]
                                        .category?.colorName],
                                  ),
                                ),
                              ),
                              title: Text(
                                context.tr(
                                        '${state.transactions[index].category?.name?.toLowerCase()}') ??
                                    ' ',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 9, top: 4),
                                child: Text(
                                  state.transactions[index].dateOfTransaction
                                      .toString()
                                      .substring(0, 10),
                                ),
                              ),
                              trailing: Text(
                                locale.languageCode == 'en'
                                    ? translateDigits(
                                        '\$'
                                        ' ${state.transactions[index].amount}',
                                        locale)
                                    : translateDigits(
                                            '${state.transactions[index].amount}',
                                            locale) +
                                        ' ' +
                                        '£',
                                style: state.transactions[index].isExpense
                                    ? const TextStyle(
                                        fontSize: 19,
                                        color: Colors.red,
                                      )
                                    : const TextStyle(
                                        fontSize: 19,
                                        color: Colors.green,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

String translateDigits(String input, Locale locale) {
  const englishDigits = '0123456789';
  const arabicDigits = '٠١٢٣٤٥٦٧٨٩';

  if (locale.languageCode == 'ar') {
    return input.split('').map((char) {
      if (englishDigits.contains(char)) {
        return arabicDigits[englishDigits.indexOf(char)];
      }
      return char;
    }).join();
  }
  return input;
}
