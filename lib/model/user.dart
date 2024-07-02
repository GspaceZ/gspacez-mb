class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  @override
  String toString() {
    return 'User(email: $email, password: $password, firstName: $firstName, lastName: $lastName,)';
  }
}
