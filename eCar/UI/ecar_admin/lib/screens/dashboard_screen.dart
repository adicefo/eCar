import 'package:ecar_admin/models/Admin/admin.dart';
import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/Notification/notification.dart' as Model;
import 'package:ecar_admin/models/CompanyPrice/companyPrice.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/models/Statistics/statistics.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/providers/admin_provider.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/companyPrice_provider.dart';
import 'package:ecar_admin/providers/driverVehicle_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/notification_provider.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/providers/statistics_provider.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DriverProvider driverProvider;
  late ClientProvider clientProvider;
  late RentProvider rentProvider;
  late RouteProvider routeProvider;
  late VehicleProvider vehicleProvider;
  late NotificationProvider notificationProvider;
  late ReviewProvider reviewProvider;
  late AdminProvider adminProvider;
  late StatisticsProvider statisticsProvider;
  late CompanyPriceProvider companyPriceProvider;
  late DriverVehicleProvider driverVehicleProvider;

  SearchResult<Driver>? drivers;
  SearchResult<Client>? clients;
  SearchResult<Model.Route>? routes;
  SearchResult<Rent>? rents;
  SearchResult<Model.Notification>? notifications;
  SearchResult<Review>? reviews;
  SearchResult<Vehicle>? vehicles;
  SearchResult<Admin>? admins;
  SearchResult<Statistics>? statistics;
  SearchResult<CompanyPrice>? companyPrices;
  SearchResult<DriverVehicle>? driverVehicles;

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    driverProvider = context.read<DriverProvider>();
    clientProvider = context.read<ClientProvider>();
    routeProvider = context.read<RouteProvider>();
    vehicleProvider = context.read<VehicleProvider>();
    rentProvider = context.read<RentProvider>();
    notificationProvider = context.read<NotificationProvider>();
    reviewProvider = context.read<ReviewProvider>();
    adminProvider = context.read<AdminProvider>();
    companyPriceProvider = context.read<CompanyPriceProvider>();
    statisticsProvider = context.read<StatisticsProvider>();
    driverVehicleProvider = context.read<DriverVehicleProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      drivers = await driverProvider.get();
      clients = await clientProvider.get();
      routes = await routeProvider.get();
      vehicles = await vehicleProvider.get();
      rents = await rentProvider.get();
      notifications = await notificationProvider.get();
      reviews = await reviewProvider.get();
      admins = await adminProvider.get();
      statistics = await statisticsProvider.get();
      companyPrices = await companyPriceProvider.get();
      driverVehicles = await driverVehicleProvider.get();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required int? count,
    Color color = Colors.blue,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color.fromARGB(255, 242, 198, 251),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.15),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 16),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                count?.toString() ?? "0",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Dashboard",
        isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                  ),
                ),
              )
            : Container(
                child: Column(
                children: [_buildDashboard()],
              )));
  }

  Widget _buildDashboard() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: const EdgeInsets.all(24),
        children: [
          _buildDashboardCard(
            icon: Icons.person,
            title: "Drivers",
            count: drivers?.result.length ?? 0,
            color: Colors.blue,
          ),
          _buildDashboardCard(
            icon: Icons.people,
            title: "Clients",
            count: clients?.result.length ?? 0,
            color: Colors.green,
          ),
          _buildDashboardCard(
            icon: Icons.route,
            title: "Routes",
            count: routes?.result.length ?? 0,
            color: Colors.orange,
          ),
          _buildDashboardCard(
            icon: Icons.directions_car,
            title: "Vehicles",
            count: vehicles?.result.length ?? 0,
            color: Colors.redAccent,
          ),
          _buildDashboardCard(
            icon: Icons.shopping_cart,
            title: "Rents",
            count: rents?.result.length ?? 0,
            color: Colors.teal,
          ),
          _buildDashboardCard(
            icon: Icons.notifications,
            title: "Notifications",
            count: notifications?.result.length ?? 0,
            color: Colors.purple,
          ),
          _buildDashboardCard(
            icon: Icons.reviews,
            title: "Reviews",
            count: reviews?.result.length ?? 0,
            color: Colors.deepOrange,
          ),
          _buildDashboardCard(
            icon: Icons.admin_panel_settings,
            title: "Admins",
            count: admins?.result.length ?? 0,
            color: Colors.indigo,
          ),
          _buildDashboardCard(
            icon: Icons.bar_chart,
            title: "Statistics",
            count: statistics?.result.length ?? 0,
            color: Colors.cyan,
          ),
          _buildDashboardCard(
            icon: Icons.monetization_on,
            title: "Company Prices",
            count: companyPrices?.result.length ?? 0,
            color: Colors.lime[800]!,
          ),
          _buildDashboardCard(
            icon: Icons.drive_eta,
            title: "Driver Vehicles",
            count: driverVehicles?.count ?? 0,
            color: Colors.pink,
          ),
        ],
      ),
    );
  }
}
