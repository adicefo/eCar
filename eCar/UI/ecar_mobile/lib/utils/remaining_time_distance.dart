String formatRemainingDuration(Duration duration) {
  // total number of hours, minutes, and seconds.
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  // uild the output based on the conditions.
  if (hours > 0) {
    // When hours are present, format as "HH:MM".
    return '$hours hours $minutes minutes';
  } else if (minutes > 5) {
    // Otherwise, format as "MM" minutes.
    return '$minutes minutes';
  } else if (minutes > 0) {
    // When there are fewer than 5 minutes, format as "MM:SS".
    return '$minutes minutes $seconds seconds';
  } else {
    // When there are fewer than 1 minutes, format as "SS".
    return '$seconds seconds';
  }
}

String formatRemainingDistance(int meters) {
  if (meters >= 1000) {
    final double kilometers = meters / 1000;
    // Using toStringAsFixed to round to 1 decimal place for kilometers.
    return '${kilometers.toStringAsFixed(1)} km';
  } else {
    return '$meters m';
  }
}
