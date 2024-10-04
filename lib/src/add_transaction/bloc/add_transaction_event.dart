part of 'add_transaction_bloc.dart';

sealed class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();

  @override
  List<Object> get props => [];
}

final class Initial extends AddTransactionEvent {
  const Initial();

  @override
  List<Object> get props => [];
}

final class AddTransaction extends AddTransactionEvent {
  const AddTransaction(this.transaction);

  final LocalTransaction transaction;

  @override
  List<Object> get props => [transaction];
}

/// This class updates the selectedIcon field in the AddTransactionState
final class UpdateSelectedIcon extends AddTransactionEvent {
  const UpdateSelectedIcon(this.icon);

  final Icon icon;

  @override
  List<Object> get props => [icon];
}

/// This class updates the selectedColor field in the AddTransactionState class
final class UpdateNewCategoryColor extends AddTransactionEvent {
  const UpdateNewCategoryColor(this.color);

  final Color color;

  @override
  List<Object> get props => [color];
}

/// This class updates the selectedCategory field in the AddTransactionState class
final class UpdateSelectedCategory extends AddTransactionEvent {
  const UpdateSelectedCategory(this.category);

  final StoredCategory category;

  @override
  List<Object> get props => [category];
}

/// This class updates the isExpense field in the AddTransactionState class
final class UpdateIsExpense extends AddTransactionEvent {
  const UpdateIsExpense(this.isExpense);

  final bool isExpense;

  @override
  List<Object> get props => [isExpense];
}

/// This class updates the isIncome field in the AddTransactionState class
final class UpdateIsIncome extends AddTransactionEvent {
  const UpdateIsIncome(this.isIncome);

  final bool isIncome;

  @override
  List<Object> get props => [isIncome];
}

/// This class updates the isCategoryExpanded field in the AddTransactionState class
final class UpdateIsCategoryExpanded extends AddTransactionEvent {
  const UpdateIsCategoryExpanded(this.isCategoryExpanded);

  final bool isCategoryExpanded;

  @override
  List<Object> get props => [isCategoryExpanded];
}

///This class updates the isColorExpanded field in the AddTransactionState class
final class UpdateIsColorExpanded extends AddTransactionEvent {
  const UpdateIsColorExpanded(this.isColorExpanded);

  final bool isColorExpanded;

  @override
  List<Object> get props => [isColorExpanded];
}

/// This class updates the isCategorySelected field in the AddTransactionState class
final class UpdateIsCategorySelected extends AddTransactionEvent {
  const UpdateIsCategorySelected(this.isCategorySelected);

  final bool isCategorySelected;

  @override
  List<Object> get props => [isCategorySelected];
}

/// This class updates the tempCategory field in the AddTransactionState class
final class UpdateTempCategory extends AddTransactionEvent {
  const UpdateTempCategory(this.category);

  final StoredCategory category;

  @override
  List<Object> get props => [category];
}

///Update the Name of the TempCategory
final class UpdateTempCustomCategoryName extends AddTransactionEvent {
  const UpdateTempCustomCategoryName(this.categoryName);

  final String categoryName;

  @override
  List<Object> get props => [categoryName];
}

/// This class updates the dateTextController field in the AddTransactionState class
final class UpdateDateTextField extends AddTransactionEvent {
  const UpdateDateTextField(this.dateTextValue);

  final String dateTextValue;

  @override
  List<Object> get props => [dateTextValue];
}

/// This class updates the transactionAmountController field in the AddTransactionState class
final class UpdateTransactionAmountField extends AddTransactionEvent {
  const UpdateTransactionAmountField(this.transactionAmount);

  final String transactionAmount;

  @override
  List<Object> get props => [transactionAmount];
}

/// This class updates the isDateChoosen field in the AddTransactionState class
final class UpdateIsDateChoosen extends AddTransactionEvent {
  const UpdateIsDateChoosen(this.isDateChoosen);

  final bool isDateChoosen;

  @override
  List<Object> get props => [isDateChoosen];
}

/// This class updates the tempDate field in the AddTransactionState class
final class UpdateTempDate extends AddTransactionEvent {
  const UpdateTempDate(this.tempDate);

  final DateTime tempDate;

  @override
  List<Object> get props => [tempDate];
}

/// This class updates the tempTransaction field in the AddTransactionState class
final class UpdateTempTransaction extends AddTransactionEvent {
  const UpdateTempTransaction(this.tempTransaction);

  final LocalTransaction tempTransaction;

  @override
  List<Object> get props => [tempTransaction];
}

/// This class updates the status field in the AddTransactionState class
final class UpdateStatus extends AddTransactionEvent {
  const UpdateStatus(this.status);

  final AddTransactionStatus status;

  @override
  List<Object> get props => [status];
}

/// This class updates the categories field in the AddTransactionState class
final class UpdateCategories extends AddTransactionEvent {
  const UpdateCategories(this.categories);

  final List<StoredCategory> categories;

  @override
  List<Object> get props => [categories];
}

///Save Transaction to TransactionCategory
final class SaveTransactionToCategory extends AddTransactionEvent {
  const SaveTransactionToCategory(this.transaction, this.categoryId);

  final LocalTransaction transaction;
  final int categoryId;

  @override
  List<Object> get props => [transaction, categoryId];
}

/// Launch the AddNewCategoryPage
final class LaunchAddNewCategoryPage extends AddTransactionEvent {
  const LaunchAddNewCategoryPage();

  @override
  List<Object> get props => [];
}

/// Expand the IconPicker in Add New Category Page
final class ExpandNewIconPicker extends AddTransactionEvent {
  const ExpandNewIconPicker();

  @override
  List<Object> get props => [];
}

/// Expand the ColorPicker in Add New Category Page
final class ExpandNewColorPicker extends AddTransactionEvent {
  const ExpandNewColorPicker();

  @override
  List<Object> get props => [];
}

///Sets the Icon for the Custom Category
final class UpdateCustomCategoryIcon extends AddTransactionEvent {
  const UpdateCustomCategoryIcon(this.icon);

  final Icon icon;

  @override
  List<Object> get props => [icon];
}

final class ValidateAmountValue extends AddTransactionEvent{
final String value;
  ValidateAmountValue(this.value);

}

/// Add a new Category
final class AddNewCategory extends AddTransactionEvent {
  const AddNewCategory(this.category);

  final StoredCategory category;

  @override
  List<Object> get props => [category];
}
final class CategoryNotSelected extends AddTransactionEvent{
  @override
  List<Object> get props => [];
}