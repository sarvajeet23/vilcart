import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/model/business_model.dart';
import 'package:vilcart/model/product_model.dart';
import 'package:vilcart/view/product/repository/stock_repository.dart';
import 'package:vilcart/view/product/repository/customer_repository.dart';
import 'package:vilcart/view/product/bloc/product_event.dart';
import 'package:vilcart/view/product/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;

  List<Product> products = [];

  ProductBloc(this.productRepository, this.customerRepository)
    : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      if (event.page == 1) {
        products = [];
        if (event.canShowLoader) {
          emit(ProductLoading());
        }
      }

      try {
        List<Business> customers = await customerRepository.getAllCustomers();

        final List<Product> newProducts = await productRepository
            .fetchStockStatement(
              event.date,
              event.customerId,
              event.page,
              event.limit,
            );

        products.addAll(newProducts);

        
        emit(ProductLoaded(products, customers));
        log("Total products loaded: ${products.length}");
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
