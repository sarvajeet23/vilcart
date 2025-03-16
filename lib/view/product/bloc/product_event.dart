
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