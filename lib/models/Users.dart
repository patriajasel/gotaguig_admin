// ignore_for_file: avoid_print

class Users {
  final String userID;
  final String name;
  final String email;
  final int age;
  final String gender;

  Users(
      {required this.userID,
      required this.name,
      required this.email,
      required this.age,
      required this.gender});

  factory Users.fromSnapshot(Map<String, dynamic> snapshot) {
    String firstName = snapshot['first_name'];
    String lastName = snapshot['last_name'];
    try {
      return Users(
        userID: snapshot['user_id'] ?? '',
        name: "$firstName $lastName",
        email: snapshot['email'] ?? '',
        age: snapshot['age'] ?? 0,
        gender: snapshot['gender'] ?? '',
      );
    } catch (e) {
      print("Error parsing snapshot: $e");
      rethrow;
    }
  }
}
