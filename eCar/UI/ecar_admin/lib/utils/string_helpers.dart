import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class StringHelpers {
  static String getQueryString(Map<String, dynamic> filter,
      {String? prefix, bool inRecursion = false}) {
    String query = '';

    filter.forEach((key, value) {
      if (value is Map) {
        value.forEach((nestedKey, nestedValue) {
          query += getQueryString(
            {nestedKey: nestedValue},
            prefix: '${prefix ?? ''}$key.',
            inRecursion: true,
          );
        });
      } else if (value is List) {
        for (var item in value) {
          if (item != null && item.toString().trim().isNotEmpty) {
            query +=
                '${Uri.encodeComponent(prefix != null ? '$prefix$key' : key)}=${Uri.encodeComponent(item.toString().trim())}&';
          }
        }
      } else if (value != null) {
        if (value is DateTime) {
          value =
              "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
        }
        query +=
            '${Uri.encodeComponent(prefix != null ? '$prefix$key' : key)}=${Uri.encodeComponent(value.toString().trim())}&';
      }
    });

    if (!inRecursion && query.isNotEmpty) {
      query = query.substring(0, query.length - 1);
    }

    return query;
  }

  static Image imageFromBase64String(String? base64Image) =>
      Image.memory(base64Decode(base64Image!));
}
