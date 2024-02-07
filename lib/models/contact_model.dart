class ContactModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dob;

  ContactModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] ?? '',
    );
  }

  static ContactModel empty() => ContactModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        dob: '',
      );

  static List<ContactModel> fromList(List<dynamic> jsonList) {
    return jsonList.map((e) => ContactModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
    };
  }
}
