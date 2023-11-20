import 'package:faker_api_test/presentation/home/home_view.dart';
import 'package:faker_api_test/repositories/bottom_tabs/bottom_tabs_repository.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  onTapped(int index) {
    setState(() {
      context.read<BottomTabRepository>().changeTabIndex(index);
    });
  }

  List<Widget> tabs = [
    // MyHomePage(title: "None"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentTabIndex = context.watch<BottomTabRepository>().tabIndex;

    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentTabIndex,
        onTap: onTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: "Home",
          ),
        ],
      ),
    );
  }
}
