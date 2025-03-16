import 'package:flutter/material.dart';
import 'package:vilcart/core/constants/app_colors.dart';
import 'package:vilcart/core/constants/app_styles.dart';
import 'package:vilcart/model/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product? model;
  const ProductDetailPage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        titleSpacing: 0,
        backgroundColor: AppColors.primary,
        title: Text("Product Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                color: AppColors.cardColor,
                elevation: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(
                        model?.skuUpcEan ?? "No Name",
                        style: AppStyles.cardTitle,
                      ),
                      subtitle: Text(
                        model?.productName ?? "productName null",
                        style: AppStyles.cardSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 2,
                  mainAxisExtent: 100,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.cardColor,
                    elevation: 0.1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Text(
                              _getLeadingText(index),
                              style: AppStyles.subtitle,
                            ),
                            trailing: _getIcon(index),
                          ),
                          Text(
                            _getText(model, index) ?? "0",
                            style: AppStyles.cardTitle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _getText(Product? model, int index) {
    if (index == 0) {
      return model?.openingStock?.toString();
    } else if (index == 1) {
      return model?.openingStock?.toString();
    } else if (index == 2) {
      return model?.openingStock?.toString();
    } else {
      return model?.openingStock?.toString();
    }
  }

  String _getLeadingText(int index) {
    if (index == 0) {
      return "Opening";
    } else if (index == 1) {
      return "Reciept";
    } else if (index == 2) {
      return "Dispatch";
    } else {
      return "Closing";
    }
  }

  Icon _getIcon(int index) {
    if (index == 0) {
      return Icon(Icons.pest_control_rodent, color: Colors.red);
    } else if (index == 1) {
      return Icon(Icons.receipt, color: Colors.blue);
    } else if (index == 2) {
      return Icon(Icons.fire_truck_sharp, color: Colors.purple);
    } else {
      return Icon(Icons.pie_chart_outline_sharp, color: Colors.green);
    }
  }
}
