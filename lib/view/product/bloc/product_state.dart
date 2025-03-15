import 'package:vilcart/model/business_model.dart';
import 'package:vilcart/model/product_model.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final String date;
  final int customerId;
  final int page;
  final int limit;
  final bool canShowLoader;

  FetchProducts(
    this.date,
    this.customerId,
    this.page,
    this.limit,
    this.canShowLoader,
  );
}

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Business> customers;

  ProductLoaded(this.products, this.customers);
}
class ProductError extends ProductState {
  final String error;
  ProductError(this.error);
}