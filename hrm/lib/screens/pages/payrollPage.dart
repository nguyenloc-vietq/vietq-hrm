import 'package:flutter/material.dart';

class Payrollpage extends StatefulWidget {
  const Payrollpage({super.key});

  @override
  State<Payrollpage> createState() => _PayrollpageState();
}

class _PayrollpageState extends State<Payrollpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Payroll Page'),
      ),
    );
  }
}
