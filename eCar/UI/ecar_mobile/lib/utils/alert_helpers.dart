import 'package:flutter/material.dart';

class AlertHelpers {
  static void showAlert(
    context,
    title,
    text,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(text),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            ));
  }

  static Future<bool?> deleteConfirmation(context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
static Future<bool?> vehicelAssignmentConfirmation(BuildContext context,
      {String text = "Are you sure that you have not already assigned a vehicle?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Assignment"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Assign", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> vehicelReturnConfirmation(BuildContext context,
      {String text = "Are you sure that you want to return your vehicle?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Assignment"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Return", style: TextStyle(color: const Color.fromARGB(255, 255, 20, 56))),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> editConfirmation(BuildContext context,
      {String text = "Are you sure you want to edit this item?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Edit"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Edit", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> changePasswordConfirmation(BuildContext context,
      {String text = "Are you sure you want to change your password?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Password Change"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Change", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> routeSendConfirmation(BuildContext context,
      {String text = "Are you sure you want to send this route request?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Send"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Send", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> rentRequestConfirmation(BuildContext context,
      {String text = "Are you sure you want to send this rent request?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Send"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Send", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> reviewSaveConfirmation(BuildContext context,
      {String text = "Are you sure you want to save this review?"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Save"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Save", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
  
}
