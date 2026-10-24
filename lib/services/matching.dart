import '../models.dart';

List<Passenger> rankPassengers(
  Iterable<Passenger> passengers,
  String destination, {
  String terminal = 'T2',
}) {
  final ranked = passengers.toList();
  ranked.sort((a, b) {
    final scoreA = calculateMatchScore(a, destination, terminal: terminal);
    final scoreB = calculateMatchScore(b, destination, terminal: terminal);
    if (scoreA != scoreB) return scoreB.compareTo(scoreA); // Descending score
    final detour = a.detourMinutes.compareTo(b.detourMinutes);
    if (detour != 0) return detour;
    return a.departureMinutes.compareTo(b.departureMinutes);
  });
  return ranked;
}

/// 4-Factor Configurable Score Model (0 to 100)
/// 1. Destination Proximity: 40%
/// 2. Departure Window: 25%
/// 3. Terminal Match: 20%
/// 4. Group Capacity: 15%
int calculateMatchScore(
  Passenger passenger,
  String targetDestination, {
  String terminal = 'T2',
}) {
  var score = 0.0;

  // Factor 1: Destination Similarity (Max 40 points)
  if (passenger.matches(targetDestination)) {
    score += 40.0;
  } else if (passenger.detourMinutes <= 15) {
    score += 30.0;
  } else if (passenger.detourMinutes <= 30) {
    score += 20.0;
  } else {
    score += 10.0;
  }

  // Factor 2: Departure Time Compatibility (Max 25 points)
  if (passenger.departureMinutes <= 20) {
    score += 25.0;
  } else if (passenger.departureMinutes <= 40) {
    score += 20.0;
  } else {
    score += 12.0;
  }

  // Factor 3: Terminal Compatibility (Max 20 points)
  score += 20.0; // Same airport CSMIA cluster

  // Factor 4: Group Capacity / Rating (Max 15 points)
  score += (passenger.rating / 5.0) * 15.0;

  return score.round().clamp(60, 99);
}

String getMatchExplanation(Passenger passenger, String targetDestination) {
  if (passenger.matches(targetDestination)) {
    return 'Exact destination match • Departing in ${passenger.departureMinutes} mins';
  }
  return 'Nearby area (${passenger.detourMinutes} min detour) • High route overlap';
}
