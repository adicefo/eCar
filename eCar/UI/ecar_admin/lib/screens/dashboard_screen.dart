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
import 'package:ecar_admin/screens/admin_screen.dart';
import 'package:ecar_admin/screens/clients_details_screen.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/company_prices_screen.dart';
import 'package:ecar_admin/screens/driverVehicle_screen.dart';
import 'package:ecar_admin/screens/driver_details_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/notification_details_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
import 'package:ecar_admin/screens/rent_screen.dart';
import 'package:ecar_admin/screens/reports_screen.dart';
import 'package:ecar_admin/screens/review_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:ecar_admin/screens/statistics_screen.dart';
import 'package:ecar_admin/screens/vehicle_screen.dart';
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
  required Widget screen,
  Color color = Colors.blue,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => screen),
      );
    },
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
            // icon in circle
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 16),

            // title
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

            // count
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
Widget _buildQuickActionCard({
  required IconData icon,
  required String title,
  required String description,
  required VoidCallback onTap,
  Color color = Colors.blue,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon circle
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            // Title & description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
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
              color: Colors.white,
                child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 250,top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text("Total active items",style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(width: 170,),
                ElevatedButton.icon(onPressed: ()=>{
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ReportsScreen()))
                }, label:  Text("Reports"),
                style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(150,50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal:32),
            ),
            icon: Icon(Icons.analytics),)
                    ],
                  ),),Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Quick Actions",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.person_add,
              title: "Add Driver",
              description: "Create a new driver",
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DriverDetailsScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.group_add,
              title: "Add Client",
              description: "Register a new client",
              color: Colors.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ClientsDetailsScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.notifications_active,
              title: "Add Notification",
              description: "Send a new notification",
              color: Colors.deepPurple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationDetailsScreen()),
                );
              },
            ),
          ),
        ],
      ),
    ],
  ),
),_buildDashboard()],
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
            screen: DriversListScreen(),
            color: Colors.blue,
          ),
          _buildDashboardCard(
            icon: Icons.people,
            title: "Clients",
            count: clients?.result.length ?? 0,
            color: Colors.green,
            screen: ClientListScreen()
          ),
          _buildDashboardCard(
            icon: Icons.route,
            title: "Routes",
            count: routes?.result.length ?? 0,
            color: Colors.orange,
            screen: RouteListScreen(),
          ),
          _buildDashboardCard(
            icon: Icons.directions_car,
            title: "Vehicles",
            count: vehicles?.result.length ?? 0,
            color: Colors.redAccent,
            screen: VehicleScreen()
          ),
          _buildDashboardCard(
            icon: Icons.shopping_cart,
            title: "Rents",
            count: rents?.result.length ?? 0,
            color: Colors.teal,
            screen: RentScreen(),
          ),
          _buildDashboardCard(
            icon: Icons.notifications,
            title: "Notifications",
            count: notifications?.result.length ?? 0,
            color: Colors.purple,
            screen:NotificationScreen(),
          ),
          _buildDashboardCard(
            icon: Icons.reviews,
            title: "Reviews",
            count: reviews?.result.length ?? 0,
            color: Colors.deepOrange,
            screen: ReviewScreen(),
          ),
          _buildDashboardCard(
            icon: Icons.admin_panel_settings,
            title: "Admins",
            count: admins?.result.length ?? 0,
            color: Colors.indigo,
            screen: AdminScreen(),
          ),
          _buildDashboardCard(
            icon: Icons.bar_chart,
            title: "Statistics",
            count: statistics?.result.length ?? 0,
            screen: StatisticsScreen(),
            color: Colors.cyan,
          ),
          _buildDashboardCard(
            icon: Icons.monetization_on,
            title: "Company Prices",
            count: companyPrices?.result.length ?? 0,
            screen: CompanyPricesScreen(),
            color: Colors.lime[800]!,
          ),
          _buildDashboardCard(
            icon: Icons.drive_eta,
            title: "Driver Vehicles",
            count: driverVehicles?.count ?? 0,
            color: Colors.pink,
            screen: DriverVehicleScreen(),

          ),
        ],
      ),
    );
  }
}
