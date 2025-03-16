import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/core/constants/app_colors.dart';
import 'package:vilcart/core/constants/app_styles.dart';
import 'package:vilcart/view/auth/bloc/login_bloc.dart';
import 'package:vilcart/view/auth/bloc/login_event.dart';
import 'package:vilcart/view/auth/bloc/login_state.dart';
import 'package:vilcart/view/product/bloc/product_event.dart';
import 'package:vilcart/view/product/bloc/product_state.dart';
import 'package:vilcart/view/product/bloc/product_bloc.dart';
import 'package:vilcart/model/product_model.dart';
import 'package:vilcart/model/business_model.dart';
import 'package:vilcart/view/product_details/product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int page = 1;
  final int limit = 10;
  int selectedCustomerId = 18;
  String selectedDate = "2025-03-15";
  final scrollController = ScrollController();
  final controller = TextEditingController();
  String searchQuery = "";
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts(true);
    scrollController.addListener(_onScroll);
  }

  void _fetchProducts(bool canShowLoader) {
    debugPrint(
      "Fetching products → Date: $selectedDate, Customer: $selectedCustomerId, Page: $page, Limit: $limit",
    );
    context.read<ProductBloc>().add(
      FetchProducts(
        selectedDate,
        selectedCustomerId,
        page,
        limit,
        canShowLoader,
      ),
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        page++;
      });
      _fetchProducts(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  page = 1;
                });
                _fetchProducts(true);
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                // Trigger logout.
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoaded) {
                if (_isLoadingMore) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading && page == 1) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state is ProductLoaded) {
                  List<Product> products = state.products;
                  List<Business> customers = state.customers;
                  log("Final Length => ${products.length}");

                  final filteredProducts =
                      searchQuery.isEmpty
                          ? products
                          : products.where((product) {
                            final productName =
                                product.productName?.toLowerCase() ?? '';
                            final sku = product.skuUpcEan?.toLowerCase() ?? '';
                            final query = searchQuery.toLowerCase();
                            return productName.contains(query) ||
                                sku.contains(query);
                          }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<int>(
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: selectedCustomerId,
                          hint: Text('Select Customer'),
                          items:
                              customers.map((Business customer) {
                                return DropdownMenuItem<int>(
                                  value: customer.id,
                                  child: Text(
                                    customer.businessName ?? "Unknown",
                                  ),
                                );
                              }).toList(),
                          onChanged: (int? newCustomerId) {
                            if (newCustomerId != null) {
                              setState(() {
                                selectedCustomerId = newCustomerId;
                                page = 1;
                              });
                              _fetchProducts(true);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: controller,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_today),
                                hintText: "Select date",
                                hintStyle: AppStyles.hintText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                    "selected_date",
                                    formattedDate,
                                  );
                                  setState(() {
                                    selectedDate = formattedDate;
                                    controller.text = selectedDate;
                                    page = 1;
                                  });
                                  _fetchProducts(true);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: "Search products",
                                hintStyle: AppStyles.hintText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,

                          itemCount:
                              filteredProducts.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoadingMore &&
                                index == filteredProducts.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            Product product = filteredProducts[index];
                            return Card(
                              color: Colors.white10,
                              elevation: 0,
                              child: ListTile(
                                title: Text(product.skuUpcEan ?? "N/A"),
                                subtitle: Text(product.productName ?? "N/A"),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              ProductDetailPage(model: product),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: Text('No products available.'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
