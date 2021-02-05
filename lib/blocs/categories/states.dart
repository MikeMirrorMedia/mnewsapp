import 'package:tv/models/categoryList.dart';

abstract class CategoriesState {}

class CategoriesInitState extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final CategoryList categoryList;
  CategoriesLoaded({this.categoryList});
}

class CategoriesError extends CategoriesState {
  final error;
  CategoriesError({this.error});
}
