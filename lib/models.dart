class Passenger {
  const Passenger({
    required this.id,
    required this.name,
    required this.initials,
    required this.destination,
    required this.area,
    required this.departureMinutes,
    required this.matchReason,
    required this.detourMinutes,
    this.matchPercentage = 90,
    this.rating = 4.9,
    this.ridesCount = 18,
    this.verified = true,
  });

  final int id;
  final String name;
  final String initials;
  final String destination;
  final String area;
  final int departureMinutes;
  final String matchReason;
  final int detourMinutes;
  final int matchPercentage;
  final double rating;
  final int ridesCount;
  final bool verified;

  bool matches(String chosenDestination) =>
      destination.toLowerCase() == chosenDestination.toLowerCase();
}

class Trip {
  const Trip({
    required this.id,
    required this.terminal,
    required this.destination,
    required this.members,
    required this.meetingPoint,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String terminal;
  final String destination;
  final List<String> members;
  final String meetingPoint;
  final String status;
  final DateTime createdAt;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.tripId,
    required this.sender,
    required this.body,
    required this.createdAt,
    required this.isMine,
  });

  final int id;
  final int tripId;
  final String sender;
  final String body;
  final DateTime createdAt;
  final bool isMine;
}

class SupportArticle {
  const SupportArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
  });

  final String id;
  final String title;
  final String category;
  final String content;
}

String? messageValidationError(String value) {
  if (value.trim().isEmpty) return 'Message cannot be empty.';
  if (value.length > 500) return 'Message must be 500 characters or fewer.';
  return null;
}

enum PasswordStrength { weak, medium, strong }

PasswordStrength checkPasswordStrength(String password) {
  if (password.length < 6) return PasswordStrength.weak;
  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
  final hasDigit = RegExp(r'[0-9]').hasMatch(password);
  final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  if (password.length >= 8 && hasLetter && hasDigit && hasSpecial) {
    return PasswordStrength.strong;
  }
  if (password.length >= 6 && hasLetter && hasDigit) {
    return PasswordStrength.medium;
  }
  return PasswordStrength.weak;
}
