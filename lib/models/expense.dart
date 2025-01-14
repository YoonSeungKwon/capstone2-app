import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  factory Expense({
    required double amount,
    required Category category,
    required String content,
    required String memo,
    required DateTime date,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
