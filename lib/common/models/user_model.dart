class DoctorModel {
  final String? id;
  final String? nameEnglish;
  final String? nameArabic;
  final String? nameKurdish;
  final String? email;
  final String? password;
  final String? type;
  final String? imageUrl;
  final bool? isAvailable;
  final bool? isBlocked;
  final String? gender;
  final List<String>? languages;
  final String? refreshToken;
  final String? deviceToken; // Nullable
  final Specialization? specialization;
  final double? averageRating;
  final List<Rating>? ratings; // Nullable list of ratings
  final String? accountStatus;
  final Availability? availability;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DoctorModel({
    this.id,
    this.nameEnglish,
    this.nameArabic,
    this.nameKurdish,
    this.email,
    this.password, // Optional
    this.type,
    this.imageUrl,
    this.isAvailable,
    this.isBlocked,
    this.gender,
    this.languages,
    this.refreshToken, // Optional
    this.deviceToken, // Optional
    this.specialization,
    this.averageRating,
    this.ratings,
    this.accountStatus,
    this.availability,
    this.createdAt,
    this.updatedAt,
  });

  // static String cleanName(String? name) {
  //   if (name == null) return '';
  //   return name
  //       .replaceAll('- english', '')
  //       .replaceAll('- arabic', '')
  //       .replaceAll('- kurdish', '');
  // }

  // Factory method to create DoctorModel from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    String? cleanName(String? name) {
      if (name == null) return null;
      return name
          .replaceAll(' - english', '')
          .replaceAll(' - arabic', '')
          .replaceAll(' - kurdish', '');
    }

    return DoctorModel(
      id: json['_id'],
      nameEnglish: cleanName(json['name_english']),
      nameArabic: cleanName(json['name_arabic']),
      nameKurdish: cleanName(json['name_kurdish']),
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
      specialization: json['specialization'],
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
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert DoctorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name_english': nameEnglish,
      'name_arabic': nameArabic,
      'name_kurdish': nameKurdish,
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
      'specialization': specialization,
      'averageRating': averageRating,
      'ratings': ratings?.map((rating) => rating.toJson()).toList(),
      'accountStatus': accountStatus,
      'availability': availability?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Rating {
  final String? userId;
  final String? ticketId;
  final int? value;

  Rating({
    this.userId,
    this.ticketId,
    this.value,
  });

  // Factory method to create Rating from JSON
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      ticketId: json['ticketId'],
      value: json['value'],
    );
  }

  // Method to convert Rating to JSON
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

  Availability({
    this.timeSlots,
    this.days,
  });

  // Factory method to create Availability from JSON
  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      timeSlots: json['timeSlots'] != null
          ? TimeSlot.fromJson(json['timeSlots'])
          : null,
      days: json['day'] != null ? List<String>.from(json['day']) : null,
    );
  }

  // Method to convert Availability to JSON
  Map<String, dynamic> toJson() {
    return {
      'timeSlots': timeSlots?.toJson(),
      'day': days,
    };
  }
}

class TimeSlot {
  final Time? startTime;
  final Time? endTime;

  TimeSlot({
    this.startTime,
    this.endTime,
  });

  // Factory method to create TimeSlot from JSON
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime:
          json['startTime'] != null ? Time.fromJson(json['startTime']) : null,
      endTime: json['endTime'] != null ? Time.fromJson(json['endTime']) : null,
    );
  }

  // Method to convert TimeSlot to JSON
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime?.toJson(),
      'endTime': endTime?.toJson(),
    };
  }
}

class Time {
  final String? time;
  final String? ampm;

  Time({
    this.time,
    this.ampm,
  });

  // Factory method to create Time from JSON
  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      time: json['time'],
      ampm: json['ampm'],
    );
  }

  // Method to convert Time to JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'ampm': ampm,
    };
  }
}

class Specialization {
  final String? id;
  final String? name;

  Specialization({
    this.id,
    this.name,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['time'],
      name: json['ampm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
