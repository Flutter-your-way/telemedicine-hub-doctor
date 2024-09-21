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
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      disease: json['disease'] != null
          ? Disease.fromJson(json['disease'] as Map<String, dynamic>)
          : null,
      questionsAndAnswers: (json['QuestionsAndAnswers'] as List<dynamic>?)
          ?.map((e) => QuestionsAndAnswers.fromJson(e as Map<String, dynamic>))
          .toList(),
      prescriptions: (json['prescriptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      scheduleDate: json['scheduleDate'] != null
          ? DateTime.parse(json['scheduleDate'] as String)
          : null,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      doctorPrescriptionAndNotes: json['doctorPrescriptionAndNotes'] != null
          ? DoctorPrescriptionAndNotes.fromJson(
              json['doctorPrescriptionAndNotes'] as Map<String, dynamic>)
          : null,
      forwardedNote: json['forwardedNote'] as String?,
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
    };
  }
}

class Doctor {
  final String? id;
  final String? nameEnglish;

  Doctor({
    this.id,
    this.nameEnglish,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] as String?,
      nameEnglish: json['name_english'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name_english': nameEnglish,
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

class QuestionsAndAnswers {
  final String? question;
  final String? answer;

  QuestionsAndAnswers({
    this.question,
    this.answer,
  });

  factory QuestionsAndAnswers.fromJson(Map<String, dynamic> json) {
    return QuestionsAndAnswers(
      question: json['question'] as String?,
      answer: json['answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class DoctorPrescriptionAndNotes {
  final String? note;
  final String? prescriptionKey;

  DoctorPrescriptionAndNotes({
    this.note,
    this.prescriptionKey,
  });

  factory DoctorPrescriptionAndNotes.fromJson(Map<String, dynamic> json) {
    return DoctorPrescriptionAndNotes(
      note: json['note'] as String?,
      prescriptionKey: json['prescriptionKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'prescriptionKey': prescriptionKey,
    };
  }
}
