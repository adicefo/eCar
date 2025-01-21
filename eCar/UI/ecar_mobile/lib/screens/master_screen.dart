import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MasterScreen extends StatefulWidget {
  String? clientOrDriver;
  MasterScreen({super.key, this.clientOrDriver});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  User? user = null;
  bool isLoading = true;
  late UserProvider userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    _initForm();
  }

  Future _initForm() async {
    user = await userProvider.getUserFromToken();
    print("Result: ${user?.userName}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Pritisni")),
          )
        : Container(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Welcome ${user?.userName}")),
          );
  }
}
