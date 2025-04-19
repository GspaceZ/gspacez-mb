enum UserRole {
  pending("PENDING"),
  admin("ADMIN"),
  member("MEMBER");

  final String description;

  const UserRole(this.description);

  String get label => description;
}
