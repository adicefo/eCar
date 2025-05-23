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

  static void successAlert(
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
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
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

  static Future<bool?> deleteStatisticsConfirmation(context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("WARNING"),
          content: Text(
              "Deleting statistics row can cause a problem in driver mobile logic. Do you still want to delete item"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> deletePricesConfirmation(context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("WARNING"),
          content: Text(
              "By deleting that you will DELETE FROM DATABASE ALL ROUTES with that price. Still want to delete item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> editConfirmation(BuildContext context,
      {String entity = "item"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Edit"),
          content: Text("Are you sure you want to edit this $entity?"),
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
  static Future<bool?> activeConfirmation(BuildContext context,
      {String entity = "item"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Active"),
          content: Text("Are you sure you want to make this $entity active?"),
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
              child: Text("Active", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> finishConfirmation(BuildContext context,
      {String entity = "item"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Finish"),
          content: Text("Are you sure you want to make this $entity finished?"),
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
              child: Text("Finish", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
  static Future<bool?> addCompanyPriceConfirmation(BuildContext context,
      {String entity = "item"}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Add"),
          content: Text("Are you sure you want to add new price for company"),
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
              child: Text("Add", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
