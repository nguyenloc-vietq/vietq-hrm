String formatMinutesToHHMM(int totalMinutes) {
  final int hours = totalMinutes ~/ 60; // Integer division to get full hours
  final int minutes = totalMinutes % 60; // Modulo to get remaining minutes

  // Pad with a leading zero if the number is less than 10
  final String formattedHours = hours.toString().padLeft(2, '0');
  final String formattedMinutes = minutes.toString().padLeft(2, '0');

  return '$formattedHours:$formattedMinutes';
}

void main() {
  print(formatMinutesToHHMM(90));   // Output: 01:30
  print(formatMinutesToHHMM(5));    // Output: 00:05
  print(formatMinutesToHHMM(120));  // Output: 02:00
  print(formatMinutesToHHMM(1450)); // Output: 24:10
}