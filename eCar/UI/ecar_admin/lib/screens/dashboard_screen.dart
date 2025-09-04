import 'package:ecar_admin/screens/master_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Dashboard",
        Container(
            child: Column(
          children: [_buildDashboard()],
        )));
  }

  Widget _buildDashboard() {
    return Container(
      child: Text("Still not implemented"),
    );
  }
}
