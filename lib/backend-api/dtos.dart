// Data Transfer Objects (DTOs)

class AppUserRes {
  AppUserRes({
    required this.id,
    required this.firstName,
    this.secondName,
    required this.firstLastName,
    this.secondLastName,
    this.dateOfBirth,
    this.avatar,
  });

  String id;
  String firstName;
  String? secondName;
  String firstLastName;
  String? secondLastName;
  DateTime? dateOfBirth;
  String? avatar;

  factory AppUserRes.fromJson(Map<String, dynamic> json) => AppUserRes(
    id: json["id"],
    firstName: json["first_name"],
    secondName: json["second_name"],
    firstLastName: json["first_last_name"],
    secondLastName: json["second_last_name"],
    dateOfBirth: json["date_of_birth"] == null
        ? null
        : DateTime.parse(json["date_of_birth"]),
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "second_name": secondName,
    "first_last_name": firstLastName,
    "second_last_name": secondLastName,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "avatar": avatar,
  };

  AppUserRes copyWith({
    String? id,
    String? firstName,
    String? secondName,
    String? firstLastName,
    String? secondLastName,
    DateTime? dateOfBirth,
    String? avatar,
  }) {
    return AppUserRes(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      firstLastName: firstLastName ?? this.firstLastName,
      secondLastName: secondLastName ?? this.secondLastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserRes &&
          other.id == id &&
          other.firstName == firstName &&
          other.secondName == secondName &&
          other.firstLastName == firstLastName &&
          other.secondLastName == secondLastName &&
          other.dateOfBirth == dateOfBirth &&
          other.avatar == avatar;

  @override
  int get hashCode => Object.hashAll([
    id,
    firstName,
    secondName,
    firstLastName,
    secondLastName,
    dateOfBirth,
    avatar,
  ]);
}

class AuthUserRes {
  AuthUserRes({required this.id, required this.email});

  String id;
  String email;

  factory AuthUserRes.fromJson(Map<String, dynamic> json) =>
      AuthUserRes(id: json["id"], email: json["email"]);

  Map<String, dynamic> toJson() => {"id": id, "email": email};

  AuthUserRes copyWith({String? id, String? email}) {
    return AuthUserRes(id: id ?? this.id, email: email ?? this.email);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserRes && other.id == id && other.email == email;

  @override
  int get hashCode => Object.hashAll([id, email]);
}

class CreateAppUserReq {
  CreateAppUserReq({
    required this.id,
    required this.firstName,
    this.secondName,
    required this.firstLastName,
    this.secondLastName,
    this.dateOfBirth,
  });

  String id;
  String firstName;
  String? secondName;
  String firstLastName;
  String? secondLastName;
  DateTime? dateOfBirth;

  factory CreateAppUserReq.fromJson(Map<String, dynamic> json) =>
      CreateAppUserReq(
        id: json["id"],
        firstName: json["first_name"],
        secondName: json["second_name"],
        firstLastName: json["first_last_name"],
        secondLastName: json["second_last_name"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "second_name": secondName,
    "first_last_name": firstLastName,
    "second_last_name": secondLastName,
    "date_of_birth": dateOfBirth?.toIso8601String(),
  };

  CreateAppUserReq copyWith({
    String? id,
    String? firstName,
    String? secondName,
    String? firstLastName,
    String? secondLastName,
    DateTime? dateOfBirth,
  }) {
    return CreateAppUserReq(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      firstLastName: firstLastName ?? this.firstLastName,
      secondLastName: secondLastName ?? this.secondLastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserRes &&
          other.id == id &&
          other.firstName == firstName &&
          other.secondName == secondName &&
          other.firstLastName == firstLastName &&
          other.secondLastName == secondLastName &&
          other.dateOfBirth == dateOfBirth;

  @override
  int get hashCode => Object.hashAll([
    id,
    firstName,
    secondName,
    firstLastName,
    secondLastName,
    dateOfBirth,
  ]);
}

class CreatePatientReq {
  CreatePatientReq({
    required this.appUserId,
    required this.nationalId,
    required this.municipalityId,
    this.inssId,
    this.phoneNumber,
    this.medicalNotes,
    this.occupation,
    this.neighborHood,
  });

  String appUserId;
  String nationalId;
  int municipalityId;
  int? inssId;
  String? phoneNumber;
  String? medicalNotes;
  String? occupation;
  String? neighborHood;

  factory CreatePatientReq.fromJson(Map<String, dynamic> json) =>
      CreatePatientReq(
        appUserId: json["app_user_id"],
        nationalId: json["national_id"],
        municipalityId: json["municipality_id"],
        inssId: json["inss_id"],
        phoneNumber: json["phone_number"],
        medicalNotes: json["medical_notes"],
        occupation: json["occupation"],
        neighborHood: json["neighborhood"],
      );

  Map<String, dynamic> toJson() => {
    "app_user_id": appUserId,
    "national_id": nationalId,
    "municipality_id": municipalityId,
    "inss_id": inssId,
    "phone_number": phoneNumber,
    "medical_notes": medicalNotes,
    "occupation": occupation,
    "neighborhood": neighborHood,
  };

  CreatePatientReq copyWith({
    String? appUserId,
    String? nationalId,
    int? municipalityId,
    int? inssId,
    String? phoneNumber,
    String? medicalNotes,
    String? occupation,
    String? neighborHood,
  }) {
    return CreatePatientReq(
      appUserId: appUserId ?? this.appUserId,
      nationalId: nationalId ?? this.nationalId,
      municipalityId: municipalityId ?? this.municipalityId,
      inssId: inssId ?? this.inssId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      occupation: occupation ?? this.occupation,
      neighborHood: neighborHood ?? this.neighborHood,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientRes &&
          other.appUserId == appUserId &&
          other.nationalId == nationalId &&
          other.municipalityId == municipalityId &&
          other.inssId == inssId &&
          other.phoneNumber == phoneNumber &&
          other.medicalNotes == medicalNotes &&
          other.occupation == occupation &&
          other.neighborHood == neighborHood;

  @override
  int get hashCode => Object.hashAll([
    appUserId,
    nationalId,
    municipalityId,
    inssId,
    phoneNumber,
    medicalNotes,
    occupation,
    neighborHood,
  ]);
}

class MunicipalityRes {
  MunicipalityRes({
    required this.id,
    required this.name,
    required this.department,
  });

  int id;
  String name;
  String department;

  factory MunicipalityRes.fromJson(Map<String, dynamic> json) =>
      MunicipalityRes(
        id: json["id"],
        name: json["name"],
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "department": department,
  };

  MunicipalityRes copyWith({int? id, String? name, String? department}) {
    return MunicipalityRes(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MunicipalityRes &&
          other.id == id &&
          other.name == name &&
          other.department == department;

  @override
  int get hashCode => Object.hashAll([id, name, department]);
}

class PatientRes {
  PatientRes({
    required this.id,
    required this.appUserId,
    required this.nationalId,
    required this.municipalityId,
    this.inssId,
    this.phoneNumber,
    this.medicalNotes,
    this.occupation,
    this.neighborHood,
  });

  int id;
  String appUserId;
  String nationalId;
  int municipalityId;
  int? inssId;
  String? phoneNumber;
  String? medicalNotes;
  String? occupation;
  String? neighborHood;

  factory PatientRes.fromJson(Map<String, dynamic> json) => PatientRes(
    id: json["id"],
    appUserId: json["app_user_id"],
    nationalId: json["national_id"],
    municipalityId: json["municipality_id"],
    inssId: json["inss_id"],
    phoneNumber: json["phone_number"],
    medicalNotes: json["medical_notes"],
    occupation: json["occupation"],
    neighborHood: json["neighborhood"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_user_id": appUserId,
    "national_id": nationalId,
    "municipality_id": municipalityId,
    "inss_id": inssId,
    "phone_number": phoneNumber,
    "medical_notes": medicalNotes,
    "occupation": occupation,
    "neighborhood": neighborHood,
  };

  PatientRes copyWith({
    int? id,
    String? appUserId,
    String? nationalId,
    int? municipalityId,
    int? inssId,
    String? phoneNumber,
    String? medicalNotes,
    String? occupation,
    String? neighborHood,
  }) {
    return PatientRes(
      id: id ?? this.id,
      appUserId: appUserId ?? this.appUserId,
      nationalId: nationalId ?? this.nationalId,
      municipalityId: municipalityId ?? this.municipalityId,
      inssId: inssId ?? this.inssId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      occupation: occupation ?? this.occupation,
      neighborHood: neighborHood ?? this.neighborHood,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientRes &&
          other.id == id &&
          other.appUserId == appUserId &&
          other.nationalId == nationalId &&
          other.municipalityId == municipalityId &&
          other.inssId == inssId &&
          other.phoneNumber == phoneNumber &&
          other.medicalNotes == medicalNotes &&
          other.occupation == occupation &&
          other.neighborHood == neighborHood;

  @override
  int get hashCode => Object.hashAll([
    id,
    appUserId,
    nationalId,
    municipalityId,
    inssId,
    phoneNumber,
    medicalNotes,
    occupation,
    neighborHood,
  ]);
}
