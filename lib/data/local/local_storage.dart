import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  static const String _kUserToken = 'user_token';
  static const String _kUserRefreshToken = 'user_refresh_token';
  static const String _kUserId = 'user_id';
  static const String _kUserEmail = 'user_email';
  static const String _kUserName = 'user_name';
  static const String _kUserUrlAvatar = 'url_avatar';
  static const String _kFirstName = 'first_name';
  static const String _kLastName = 'last_name';
  static const String _kNation = 'nation';
  static const String _kCity = 'city';
  static const String _kAddress = 'address';

  final _secureStorage = const FlutterSecureStorage();

  // Private constructor
  LocalStorage._internal();

  // Public factory constructor
  factory LocalStorage() => _instance;

  static LocalStorage get instance => _instance;

  FlutterSecureStorage get secureStorage => _secureStorage;

  // User token
  Future<String?> get userToken {
    return secureStorage.read(key: _kUserToken);
  }

  Future<void> saveUserToken(String? userToken) {
    return secureStorage.write(key: _kUserToken, value: userToken);
  }

  Future<void> removeUserToken() {
    return secureStorage.delete(key: _kUserToken);
  }

  // User id
  Future<String?> get userId {
    return secureStorage.read(key: _kUserId);
  }

  Future<void> saveUserId(String? userId) {
    return secureStorage.write(key: _kUserId, value: userId);
  }

  Future<void> removeUserId() {
    return secureStorage.delete(key: _kUserId);
  }

  // User email
  Future<String?> get userEmail {
    return secureStorage.read(key: _kUserEmail);
  }

  Future<void> saveUserEmail(String? userEmail) {
    return secureStorage.write(key: _kUserEmail, value: userEmail);
  }

  Future<void> removeUserEmail() {
    return secureStorage.delete(key: _kUserEmail);
  }

  // User name
  Future<String?> get userName {
    return secureStorage.read(key: _kUserName);
  }

  Future<void> saveUserName(String? userName) {
    return secureStorage.write(key: _kUserName, value: userName);
  }

  Future<void> removeUserName() {
    return secureStorage.delete(key: _kUserName);
  }

  Future<String?> get firstName {
    return secureStorage.read(key: _kFirstName);
  }

  Future<void> saveFirstName(String firstName) {
    return secureStorage.write(key: _kFirstName, value: firstName);
  }

  Future<void> removeFirstName() {
    return secureStorage.delete(key: _kFirstName);
  }

  Future<String?> get lastName {
    return secureStorage.read(key: _kLastName);
  }

  Future<void> saveLastName(String lastName) {
    return secureStorage.write(key: _kLastName, value: lastName);
  }

  Future<void> removeLastName() {
    return secureStorage.delete(key: _kLastName);
  }

  Future<String?> get nation {
    return secureStorage.read(key: _kNation);
  }

  Future<void> saveNation(String nation) {
    return secureStorage.write(key: _kNation, value: nation);
  }

  Future<void> removeNation() {
    return secureStorage.delete(key: _kNation);
  }

  Future<String?> get city {
    return secureStorage.read(key: _kCity);
  }

  Future<void> saveCity(String city) {
    return secureStorage.write(key: _kCity, value: city);
  }

  Future<void> removeCity() {
    return secureStorage.delete(key: _kCity);
  }

  Future<String?> get address {
    return secureStorage.read(key: _kAddress);
  }

  Future<void> saveAddress(String address) {
    return secureStorage.write(key: _kAddress, value: address);
  }

  Future<void> removeAddress() {
    return secureStorage.delete(key: _kAddress);
  }

  // User url avatar
  Future<String?> get userUrlAvatar {
    return secureStorage.read(key: _kUserUrlAvatar);
  }

  Future<void> saveUserUrlAvatar(String? userUrlAvatar) {
    return secureStorage.write(key: _kUserUrlAvatar, value: userUrlAvatar);
  }

  Future<void> removeUserUrlAvatar() {
    return secureStorage.delete(key: _kUserUrlAvatar);
  }

  // User refresh token
  Future<String?> get userRefreshToken {
    return secureStorage.read(key: _kUserRefreshToken);
  }

  Future<void> saveUserRefreshToken(String? userRefreshToken) async {
    if (userRefreshToken == null) return;

    return secureStorage.write(
        key: _kUserRefreshToken, value: userRefreshToken);
  }

  Future<void> removeUserRefreshToken() {
    return secureStorage.delete(key: _kUserRefreshToken);
  }

  Future<void> removeUserData() async {
    await Future.wait([
      removeUserToken(),
      removeUserRefreshToken(),
      removeUserId(),
      removeUserEmail(),
      removeUserName(),
      removeUserUrlAvatar(),
    ]);
  }

  Future<bool> isAuthenticated() async {
    final userToken = await this.userToken;
    return userToken != null;
  }
}
