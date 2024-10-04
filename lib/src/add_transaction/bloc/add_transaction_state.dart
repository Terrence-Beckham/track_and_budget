part of 'add_transaction_bloc.dart';

enum AddTransactionStatus {
  initial,
  loading,
  success,
  failure,
  addNewCategory,
  chooseCategory
}

class AddTransactionState extends Equatable {
  final AddTransactionStatus status;
  final List<StoredCategory> categories;
  final Icon selectedIcon;
  final Color selectedColor;
  final String selectedTransactionType;
  final bool isExpense;
  final bool isIncome;
  final bool isCategoryExpanded;
  final bool isColorExpanded;
  final bool isCategorySelected;
  final StoredCategory? tempCategory;
  final String dateTextField;
  final String transactionAmount;
  final bool isDateChosen;
  final DateTime tempDate;
  final LocalTransaction tempTransaction;
  final StoredCategory newCustomCategory;
  final bool isAddNewCategoryExpanded;
  final List<Icon> categoryWidgetIcons;
  final bool isAddNewCategoryColorPickerExpanded;
  final bool isAmountValidationFailed;
  final bool isCategoryUnselected;

  final AmountValidator amountValidator;
  final Icon customCategoryIcon;

  bool get didCategoryGetChosen => tempCategory != null;

  AddTransactionState({
    required this.newCustomCategory,
    required this.isAddNewCategoryColorPickerExpanded,
    required this.isColorExpanded,
    required this.tempDate,
    required this.categories,
    required this.status,
    required this.selectedIcon,
    required this.selectedColor,
    required this.selectedTransactionType,
    required this.isExpense,
    required this.isIncome,
    required this.isCategoryExpanded,
    required this.isCategorySelected,
    required this.isDateChosen,
    required this.isAddNewCategoryExpanded,
    required this.tempCategory,
    required this.dateTextField,
    required this.transactionAmount,
    required this.tempTransaction,
    required this.categoryWidgetIcons,
    required this.isAmountValidationFailed,
    required this.isCategoryUnselected,
    required this.amountValidator,
    required this.customCategoryIcon,
  });

  AddTransactionState copyWith({
    StoredCategory Function()? newCustomCategory,
    AddTransactionStatus Function()? status,
    List<StoredCategory> Function()? categories,
    List<Icon> Function()? categoryWidgetIcons,
    Icon Function()? selectedIcon,
    Color Function()? selectedColor,
    String Function()? selectedTransactionType,
    bool Function()? isExpense,
    bool Function()? isAddNewCategoryColorPickerExpanded,
    bool Function()? isAddNewCategoryExpanded,
    bool Function()? isIncome,
    bool Function()? isCategoryExpanded,
    bool Function()? isCategorySelected,
    StoredCategory Function()? tempCategory,
    String Function()? dateTextField,
    String Function()? transactionAmountController,
    bool Function()? isDateChoosen,
    bool Function()? isColorExpanded,
    DateTime Function()? tempDate,
    LocalTransaction Function()? tempTransaction,
    bool Function()? isAmountEntered,
    bool Function()? isCategoryValidated,
    AmountValidator Function()? amountValidator,
    bool Function()? isCategoryUnselected,
    Icon Function()? customCategoryIcon,
  }) {
    return AddTransactionState(
      newCustomCategory: newCustomCategory != null
          ? newCustomCategory()
          : this.newCustomCategory,
      isAddNewCategoryColorPickerExpanded:
          isAddNewCategoryColorPickerExpanded != null
              ? isAddNewCategoryColorPickerExpanded()
              : this.isAddNewCategoryColorPickerExpanded,
      categoryWidgetIcons: categoryWidgetIcons != null
          ? categoryWidgetIcons()
          : this.categoryWidgetIcons,
      isColorExpanded:
          isColorExpanded != null ? isColorExpanded() : this.isColorExpanded,
      status: status != null ? status() : this.status,
      categories: categories != null ? categories() : this.categories,
      selectedIcon: selectedIcon != null ? selectedIcon() : this.selectedIcon,
      selectedColor:
          selectedColor != null ? selectedColor() : this.selectedColor,
      selectedTransactionType: selectedTransactionType != null
          ? selectedTransactionType()
          : this.selectedTransactionType,
      isExpense: isExpense != null ? isExpense() : this.isExpense,
      isIncome: isIncome != null ? isIncome() : this.isIncome,
      isAddNewCategoryExpanded: isAddNewCategoryExpanded != null
          ? isAddNewCategoryExpanded()
          : this.isAddNewCategoryExpanded,
      isCategoryExpanded: isCategoryExpanded != null
          ? isCategoryExpanded()
          : this.isCategoryExpanded,
      isCategorySelected: isCategorySelected != null
          ? isCategorySelected()
          : this.isCategorySelected,
      tempCategory: tempCategory != null ? tempCategory() : this.tempCategory,
      dateTextField:
          dateTextField != null ? dateTextField() : this.dateTextField,
      transactionAmount: transactionAmountController != null
          ? transactionAmountController()
          : this.transactionAmount,
      isDateChosen: isDateChoosen != null ? isDateChoosen() : this.isDateChosen,
      tempDate: tempDate != null ? tempDate() : this.tempDate,
      tempTransaction:
          tempTransaction != null ? tempTransaction() : this.tempTransaction,
      isAmountValidationFailed: isAmountEntered != null
          ? isAmountEntered()
          : this.isAmountValidationFailed,
      isCategoryUnselected: isCategoryUnselected != null
          ? isCategoryUnselected()
          : this.isCategoryUnselected,
      amountValidator:
          amountValidator != null ? amountValidator() : this.amountValidator,
      customCategoryIcon: customCategoryIcon != null
          ? customCategoryIcon()
          : this.customCategoryIcon,
    );
  }

  AddTransactionState.empty()
      : status = AddTransactionStatus.initial,
        newCustomCategory = StoredCategory(),
        categoryWidgetIcons = categoryWidgets,
        categories = [],
        isColorExpanded = false,
        isAddNewCategoryColorPickerExpanded = false,
        selectedIcon = Icon(Icons.category),
        selectedColor = Colors.red,
        selectedTransactionType = "income",
        isExpense = true,
        isIncome = false,
        isCategoryExpanded = false,
        isCategorySelected = false,
        isAddNewCategoryExpanded = false,
        tempCategory = null,
        dateTextField = 'Choose Date',
        transactionAmount = '',
        isDateChosen = false,
        tempDate = DateTime.now(),
        tempTransaction = LocalTransaction(),
        isAmountValidationFailed = false,
        isCategoryUnselected = false,
        amountValidator = AmountValidator(hasError: false, errorMessage: ''),
        customCategoryIcon = Icon(Iconsax.arrow_right,color: Colors.white,);

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedIcon,
        selectedColor,
        selectedTransactionType,
        isExpense,
        isIncome,
        isCategoryExpanded,
        isCategorySelected,
        isAddNewCategoryExpanded,
        tempCategory,
        dateTextField,
        transactionAmount,
        isDateChosen,
        tempDate,
        tempTransaction,
        isAddNewCategoryColorPickerExpanded,
        newCustomCategory,
        isColorExpanded,
        isAmountValidationFailed,
        isCategoryUnselected,
        amountValidator,
        customCategoryIcon,
      ];
}

class AmountValidator extends Equatable {
  final bool hasError;
  final String errorMessage;

  AmountValidator({required this.hasError, required this.errorMessage});

  @override
  List<Object?> get props => [hasError, errorMessage];
}
