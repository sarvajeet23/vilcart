import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/model/business_model.dart';
import 'package:vilcart/repository/stock_repository.dart';
import 'package:vilcart/repository/customer_repository.dart';
import 'package:vilcart/view/product/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;

  ProductBloc(this.productRepository, this.customerRepository)
    : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      if (event.canShowLoader) {
        emit(ProductLoading());
      }
      try {
        List<Business> customers = await customerRepository.getAllCustomers();

        final products = await productRepository.fetchStockStatement(
          event.date,
          event.customerId,
          event.page,
          event.limit,
        );

        emit(ProductLoaded(products, customers));
        log("products= ${products.length}");
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
