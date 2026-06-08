class BankUser {
  final int? id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String accountName;
  final String accountNumber;

  BankUser({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.accountName,
    required this.accountNumber,
  });

  String get fullName => '$firstName $lastName';

  BankUser copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? accountName,
    String? accountNumber,
  }) {
    return BankUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'accountName': accountName,
      'accountNumber': accountNumber,
    };
  }

  factory BankUser.fromMap(Map<String, dynamic> map) {
    return BankUser(
      id: map['id'] as int?,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      accountName: map['accountName'] as String,
      accountNumber: map['accountNumber'] as String,
    );
  }
}
