import 'package:flutter/material.dart';
import 'package:vilcart/view/product/product_page.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int currentIndex = 0;

  void onChanged(int index) {
    setState(() {
      currentIndex = index;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductPage(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        currentIndex: currentIndex,
        onTap: onChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Products'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
