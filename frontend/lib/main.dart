import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';

import 'screens/transactions_screen.dart';

import 'screens/income_screen.dart';

import 'screens/scheduled_payment_screen.dart';

import 'screens/saving_goals_screen.dart';
 
void main() {

  runApp(const FinanceApp());

}
 
class FinanceApp extends StatelessWidget {

  const FinanceApp({super.key});
 
  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Finance App',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(

          seedColor: const Color(0xFF5C6BC0),

          brightness: Brightness.light,

        ),

        useMaterial3: true,

      ),

      darkTheme: ThemeData(

        colorScheme: ColorScheme.fromSeed(

          seedColor: const Color(0xFF5C6BC0),

          brightness: Brightness.dark,

        ),

        useMaterial3: true,

      ),

      themeMode: ThemeMode.system,

      home: const AppShell(),

    );

  }

}
 
class AppShell extends StatefulWidget {

  const AppShell({super.key});
 
  @override

  State<AppShell> createState() => _AppShellState();

}
 
class _AppShellState extends State<AppShell> {

  int _currentIndex = 0;
 
  static const List<Widget> _screens = [

    DashboardScreen(),

    TransactionsScreen(),

    ScheduledPaymentScreen(),

    SavingGoalsScreen(),

  ];
 
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(

        index: _currentIndex,

        children: _screens,

      ),

      bottomNavigationBar: NavigationBar(

        selectedIndex: _currentIndex,

        onDestinationSelected: (index) =>

            setState(() => _currentIndex = index),

        destinations: const [

          NavigationDestination(

            icon: Icon(Icons.dashboard_outlined),

            selectedIcon: Icon(Icons.dashboard),

            label: 'Overview',

          ),

          NavigationDestination(

            icon: Icon(Icons.receipt_long_outlined),

            selectedIcon: Icon(Icons.receipt_long),

            label: 'Transactions',

          ),

          NavigationDestination(

            icon: Icon(Icons.autorenew_outlined),

            selectedIcon: Icon(Icons.autorenew),

            label: 'Scheduled Payments',

          ),

          NavigationDestination(

            icon: Icon(Icons.savings_outlined),

            selectedIcon: Icon(Icons.savings),

            label: 'Goals',

          ),

        ],

      ),

    );

  }

}
 