// ignore_for_file: avoid_print

class Reviews {
  final String userID;
  final String name;
  final String email;
  final String mobileNumber;
  final String feedback;

  Reviews(
      {required this.userID,
      required this.name,
      required this.email,
      required this.mobileNumber,
      required this.feedback});

  factory Reviews.fromSnapshot(Map<String, dynamic> snapshot) {
    try {
      return Reviews(
        userID: snapshot['user_id'] ?? '',
        name: snapshot['name'] ?? '',
        email: snapshot['email'] ?? '',
        mobileNumber: snapshot['mobile_number'] ?? '',
        feedback: snapshot['user_reviews'] ?? '',
      );
    } catch (e) {
      print("Error parsing snapshot: $e");
      rethrow;
    }
  }
}
