DateTime? tryParseDateTime(dynamic value) {
  if (value == null) return null;
  try {
    if (value is String) {
      return DateTime.parse(value);
    }
    return null;
  } catch (e) {
    return null;
  }
}

class TicketModel {
  final String? id;
  final String? name;
  final Doctor? doctor;
  final Patient? patient;
  final Disease? disease;
  final List<QuestionsAndAnswers>? questionsAndAnswers;
  final List<String>? prescriptions;
  final DateTime? scheduleDate;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DoctorPrescriptionAndNotes? doctorPrescriptionAndNotes;
  final String? forwardedNote;
  final String? paymentLink;
  final MeetingLink? meetingLink;
  final Feedback? feedback;
  final Amount? amount;

  TicketModel({
    this.id,
    this.name,
    this.doctor,
    this.patient,
    this.disease,
    this.questionsAndAnswers,
    this.prescriptions,
    this.scheduleDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.doctorPrescriptionAndNotes,
    this.forwardedNote,
    this.paymentLink,
    this.meetingLink,
    this.feedback,
    this.amount,
  });

  // factory TicketModel.fromJson(Map<String, dynamic> json) {
  //   return TicketModel(
  //     id: json['_id'] as String?,
  //     name: json['name'] as String?,
  //     doctor: json['doctor'] != null && json['doctor'] is Map<String, dynamic>
  //         ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
  //         : null,
  //     patient:
  //         json['patient'] != null && json['patient'] is Map<String, dynamic>
  //             ? Patient.fromJson(json['patient'] as Map<String, dynamic>)
  //             : null,
  //     disease:
  //         json['disease'] != null && json['disease'] is Map<String, dynamic>
  //             ? Disease.fromJson(json['disease'] as Map<String, dynamic>)
  //             : null,
  //     questionsAndAnswers: (json['questionsAndAnswers'] as List<dynamic>?)
  //         ?.map((e) => e is Map<String, dynamic>
  //             ? QuestionsAndAnswers.fromJson(e)
  //             : null)
  //         .whereType<QuestionsAndAnswers>()
  //         .toList(),
  //     prescriptions: (json['prescriptions'] as List<dynamic>?)
  //         ?.map((e) => e.toString())
  //         .toList(),
  //     scheduleDate: json['scheduleDate'] != null
  //         ? DateTime.tryParse(json['scheduleDate'] as String)
  //         : null,
  //     status: json['status'] as String?,
  //     createdAt: json['createdAt'] != null
  //         ? DateTime.tryParse(json['createdAt'] as String)
  //         : null,
  //     updatedAt: json['updatedAt'] != null
  //         ? DateTime.tryParse(json['updatedAt'] as String)
  //         : null,
  //     doctorPrescriptionAndNotes: json['doctorPrescriptionAndNotes'] != null &&
  //             json['doctorPrescriptionAndNotes'] is Map<String, dynamic>
  //         ? DoctorPrescriptionAndNotes.fromJson(
  //             json['doctorPrescriptionAndNotes'] as Map<String, dynamic>)
  //         : null,
  //     forwardedNote: json['forwardedNote'] as String?,
  //     paymentLink: json['paymentLink'] as String?,
  //     meetingLink: json['meetingLink'] != null &&
  //             json['meetingLink'] is Map<String, dynamic>
  //         ? MeetingLink.fromJson(json['meetingLink'] as Map<String, dynamic>)
  //         : null,
  //     feedback:
  //         json['feedback'] != null && json['feedback'] is Map<String, dynamic>
  //             ? Feedback.fromJson(json['feedback'] as Map<String, dynamic>)
  //             : null,
  //     amount: json['amount'] != null && json['amount'] is Map<String, dynamic>
  //         ? Amount.fromJson(json['amount'] as Map<String, dynamic>)
  //         : null,
  //   );
  // }
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      patient:
          json['patient'] != null ? Patient.fromJson(json['patient']) : null,
      disease:
          json['disease'] != null ? Disease.fromJson(json['disease']) : null,
      questionsAndAnswers: (json['QuestionsAndAnswers'] as List?)
          ?.map((e) => QuestionsAndAnswers.fromJson(e))
          .toList(),
      prescriptions:
          (json['prescriptions'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      scheduleDate: tryParseDateTime(json['scheduleDate']),
      status: json['status']?.toString(),
      createdAt: tryParseDateTime(json['createdAt']),
      updatedAt: tryParseDateTime(json['updatedAt']),
      doctorPrescriptionAndNotes: json['doctorPrescriptionAndNotes'] != null
          ? DoctorPrescriptionAndNotes.fromJson(
              json['doctorPrescriptionAndNotes'])
          : null,
      forwardedNote: json['forwardedNote']?.toString() ?? '',
      paymentLink: json['paymentLink']?.toString(),
      meetingLink: json['meetingLink'] != null
          ? MeetingLink.fromJson(json['meetingLink'])
          : null,
      feedback:
          json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null,
      amount: json['amount'] != null ? Amount.fromJson(json['amount']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'doctor': doctor?.toJson(),
      'patient': patient?.toJson(),
      'disease': disease?.toJson(),
      'QuestionsAndAnswers':
          questionsAndAnswers?.map((e) => e.toJson()).toList(),
      'prescriptions': prescriptions,
      'scheduleDate': scheduleDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'doctorPrescriptionAndNotes': doctorPrescriptionAndNotes?.toJson(),
      'forwardedNote': forwardedNote,
      'paymentLink': paymentLink,
      'meetingLink': meetingLink?.toJson(),
      'feedback': feedback?.toJson(),
      'amount': amount?.toJson(),
    };
  }
}

class Amount {
  final int? value;
  final String? currency;

  Amount({
    this.value,
    this.currency,
  });
  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      value: json['value'] as int?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'currency': currency,
    };
  }
}

class Doctor {
  final String? id;
  final String? nameEnglish;
  final String? price;
  final String? currencyType;

  Doctor({
    this.id,
    this.nameEnglish,
    this.price,
    this.currencyType,
  });

  factory Doctor.fromJson(dynamic json) {
    if (json is String) return Doctor(id: json);
    return Doctor(
      id: json['_id'] as String?,
      nameEnglish: json['name_english'] as String?,
      price: json['price'] as String?,
      currencyType: json['currencyType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name_english': nameEnglish,
      'price': price,
      'currencyType': currencyType
    };
  }
}

class Patient {
  final String? id;
  final String? name;
  final String? email;
  final String? address;
  final DateTime? age;
  final String? bloodGroup;
  final String? city;
  final String? country;
  final String? fatherName;
  final String? gender;
  final String? grandFatherName;
  final int? height;
  final String? married;
  final String? pregnancyStatus;
  final int? weight;

  Patient({
    this.id,
    this.name,
    this.email,
    this.address,
    this.age,
    this.bloodGroup,
    this.city,
    this.country,
    this.fatherName,
    this.gender,
    this.grandFatherName,
    this.height,
    this.married,
    this.pregnancyStatus,
    this.weight,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      age: json['age'] != null ? DateTime.parse(json['age'] as String) : null,
      bloodGroup: json['bloodGroup'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      fatherName: json['fatherName'] as String?,
      gender: json['gender'] as String?,
      grandFatherName: json['grandFatherName'] as String?,
      height: json['height'] as int?,
      married: json['married'] as String?,
      pregnancyStatus: json['pregnancyStatus'] as String?,
      weight: json['weight'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'address': address,
      'age': age?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'city': city,
      'country': country,
      'fatherName': fatherName,
      'gender': gender,
      'grandFatherName': grandFatherName,
      'height': height,
      'married': married,
      'pregnancyStatus': pregnancyStatus,
      'weight': weight,
    };
  }
}

class Disease {
  final String? id;
  final String? name;

  Disease({
    this.id,
    this.name,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class Feedback {
  final String? id;
  final String? userId;
  final String? ticketId;
  final String? feedbackReason;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Feedback({
    this.id,
    this.userId,
    this.ticketId,
    this.feedbackReason,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['_id'] as String?,
      userId: json['user'] as String?,
      ticketId: json['ticket'] as String?,
      feedbackReason: json['feedbackReason'] as String?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'ticket': ticketId,
      'feedbackReason': feedbackReason,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class QuestionsAndAnswers {
  final String? question;
  final dynamic answer;
  final String? id;

  QuestionsAndAnswers({
    this.question,
    this.answer,
    this.id,
  });

  factory QuestionsAndAnswers.fromJson(Map<String, dynamic> json) {
    return QuestionsAndAnswers(
      question: json['question']?.toString(),
      answer: json['answer'] is List
          ? json['answer'].map((e) => e.toString()).toList()
          : json['answer']?.toString(),
      id: json['_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      '_id': id,
    };
  }
}

class DoctorPrescriptionAndNotes {
  String? note;
  List<String>? prescriptionUrls;

  DoctorPrescriptionAndNotes({this.note, this.prescriptionUrls});
  DoctorPrescriptionAndNotes.fromJson(Map<String, dynamic> json) {
    note = json['note']?.toString() ?? '';
    prescriptionUrls =
        (json['prescriptions'] as List?)?.map((e) => e.toString()).toList() ??
            [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['prescriptionUrls'] = prescriptionUrls;
    return data;
  }
}

class MeetingLink {
  final String? google;
  final String? zoom;
  final String? agora;

  MeetingLink({
    this.google,
    this.zoom,
    this.agora,
  });

  factory MeetingLink.fromJson(Map<String, dynamic> json) {
    return MeetingLink(
      google: json['google'] as String?,
      zoom: json['zoom'] as String?,
      agora: json['agora'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'google': google,
      'zoom': zoom,
      'agora': agora,
    };
  }
}
