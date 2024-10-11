class DoctorModel {
  final String? id;
  final String? name;

  final String? email;
  final String? password;
  final String? type;
  final String? imageUrl;
  final bool? isAvailable;
  final bool? isBlocked;
  final String? gender;
  final List<String>? languages;
  final String? refreshToken;
  final String? deviceToken;
  final Specialization? specialization;
  final double? averageRating;
  final List<Rating>? ratings;
  final String? accountStatus;
  final Availability? availability;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final String? deletedAt;

  DoctorModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.type,
    this.imageUrl,
    this.isAvailable,
    this.isBlocked,
    this.gender,
    this.languages,
    this.refreshToken,
    this.deviceToken,
    this.specialization,
    this.averageRating,
    this.ratings,
    this.accountStatus,
    this.availability,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
  });

  // Helper to clean the name string
  String? cleanName(String? name) {
    if (name == null) return null;
    return name
        .replaceAll(' - english', '')
        .replaceAll(' - arabic', '')
        .replaceAll(' - kurdish', '');
  }

  // Factory method to create DoctorModel from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        type: json['type'],
        imageUrl: json['imageUrl'],
        isAvailable: json['isAvailable'],
        isBlocked: json['isBlocked'],
        gender: json['gender'],
        languages: (json['languages'] != null)
            ? List<String>.from(json['languages'])
            : null,
        refreshToken: json['refreshToken'],
        deviceToken: json['deviceToken'],
        specialization: json['specialization'] != null
            ? Specialization.fromJson(json['specialization'])
            : null,
        averageRating: json['averageRating']?.toDouble(),
        ratings: (json['ratings'] != null)
            ? List<Rating>.from(
                json['ratings'].map((rating) => Rating.fromJson(rating)),
              )
            : null,
        accountStatus: json['accountStatus'],
        availability: json['availability'] != null
            ? Availability.fromJson(json['availability'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        isDeleted: json['isDeleted'],
        deletedAt: json['deleteAt']);
  }

  // Method to convert DoctorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'isBlocked': isBlocked,
      'gender': gender,
      'languages': languages,
      'refreshToken': refreshToken,
      'deviceToken': deviceToken,
      'specialization': specialization?.toJson(),
      'averageRating': averageRating,
      'ratings': ratings?.map((rating) => rating.toJson()).toList(),
      'accountStatus': accountStatus,
      'availability': availability?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deleteAt': deletedAt,
    };
  }
}

class Rating {
  final String? userId;
  final String? ticketId;
  final int? value;

  Rating({this.userId, this.ticketId, this.value});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      ticketId: json['ticketId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'ticketId': ticketId,
      'value': value,
    };
  }
}

class Availability {
  final TimeSlot? timeSlots;
  final List<String>? days;

  Availability({this.timeSlots, this.days});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      timeSlots: json['timeSlots'] != null
          ? TimeSlot.fromJson(json['timeSlots'])
          : null,
      days: json['day'] != null ? List<String>.from(json['day']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeSlots': timeSlots?.toJson(),
      'day': days,
    };
  }
}

class TimeSlot {
  final String? startTime;
  final String? endTime;

  TimeSlot({this.startTime, this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class Specialization {
  final String? id;
  final String? name;

  Specialization({this.id, this.name});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class Education {
  final String? id;
  final String? nameEnglish;
  final String? nameArabic;
  final String? nameKurdish;
  final String? universityNameEnglish;
  final String? universityNameArabic;
  final String? universityNameKurdish;
  final String? year;

  Education({
    this.id,
    this.nameEnglish,
    this.nameArabic,
    this.nameKurdish,
    this.universityNameEnglish,
    this.universityNameArabic,
    this.universityNameKurdish,
    this.year,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'],
      nameEnglish: json['nameEnglish'],
      nameArabic: json['nameArabic'],
      nameKurdish: json['nameKurdish'],
      universityNameEnglish: json['universityNameEnglish'],
      universityNameArabic: json['universityNameArabic'],
      universityNameKurdish: json['universityNameKurdish'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'nameKurdish': nameKurdish,
      'universityNameEnglish': universityNameEnglish,
      'universityNameArabic': universityNameArabic,
      'universityNameKurdish': universityNameKurdish,
      'year': year,
    };
  }
}
