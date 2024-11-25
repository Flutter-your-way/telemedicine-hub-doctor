class MedicalHistoryModel {
  final String id;
  final String user;
  final String patient;
  final MedicalHistory medicalHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalHistoryModel({
    required this.id,
    required this.user,
    required this.patient,
    required this.medicalHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      patient: json['patient'] ?? '',
      medicalHistory: MedicalHistory.fromJson(json['medicalHistory'] ?? {}),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class MedicalHistory {
  final Allergies allergies;
  final CurrentMedication currentMedication;
  final Conditions conditions;
  final PreviousSurgeries previousSurgeries;
  final WomensHealth womensHealth;
  final FamilyHistory familyHistory;

  MedicalHistory({
    required this.allergies,
    required this.currentMedication,
    required this.conditions,
    required this.previousSurgeries,
    required this.womensHealth,
    required this.familyHistory,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      allergies: Allergies.fromJson(json['allergies'] ?? {}),
      currentMedication:
          CurrentMedication.fromJson(json['currentMedication'] ?? {}),
      conditions: Conditions.fromJson(json['conditions'] ?? {}),
      previousSurgeries:
          PreviousSurgeries.fromJson(json['previousSurgeries'] ?? {}),
      womensHealth: WomensHealth.fromJson(json['womensHealth'] ?? {}),
      familyHistory: FamilyHistory.fromJson(json['familyHistory'] ?? {}),
    );
  }
}

// Helper models for each section
class Allergies {
  final bool hasAllergies;
  final String details;

  Allergies({required this.hasAllergies, required this.details});

  factory Allergies.fromJson(Map<String, dynamic> json) {
    return Allergies(
      hasAllergies: json['hasAllergies'] ?? false,
      details: json['details'] ?? '',
    );
  }
}

class CurrentMedication {
  final bool hasMedication;
  final String details;

  CurrentMedication({required this.hasMedication, required this.details});

  factory CurrentMedication.fromJson(Map<String, dynamic> json) {
    return CurrentMedication(
      hasMedication: json['hasMedication'] ?? false,
      details: json['details'] ?? '',
    );
  }
}

class Conditions {
  final String alcoholism;
  final String asthma;
  final String cancer;
  final String depressionAnxiety;
  final String diabetes;
  final String emphysema;
  final String heartDisease;
  final String hypertension;
  final String highCholesterol;
  final String thyroidDisease;
  final String kidneyDisease;
  final String migraineHeadaches;
  final String stroke;
  final String other;

  Conditions({
    required this.alcoholism,
    required this.asthma,
    required this.cancer,
    required this.depressionAnxiety,
    required this.diabetes,
    required this.emphysema,
    required this.heartDisease,
    required this.hypertension,
    required this.highCholesterol,
    required this.thyroidDisease,
    required this.kidneyDisease,
    required this.migraineHeadaches,
    required this.stroke,
    required this.other,
  });

  factory Conditions.fromJson(Map<String, dynamic> json) {
    return Conditions(
      alcoholism: json['alcoholism'] ?? 'no',
      asthma: json['asthma'] ?? 'no',
      cancer: json['cancer'] ?? 'no',
      depressionAnxiety: json['depressionAnxiety'] ?? 'no',
      diabetes: json['diabetes'] ?? 'no',
      emphysema: json['emphysema'] ?? 'no',
      heartDisease: json['heartDisease'] ?? 'no',
      hypertension: json['hypertension'] ?? 'no',
      highCholesterol: json['highCholesterol'] ?? 'no',
      thyroidDisease: json['thyroidDisease'] ?? 'no',
      kidneyDisease: json['kidneyDisease'] ?? 'no',
      migraineHeadaches: json['migraineHeadaches'] ?? 'no',
      stroke: json['stroke'] ?? 'no',
      other: json['other'] ?? '',
    );
  }
}

class PreviousSurgeries {
  final bool hasSurgeries;
  final List<Surgery> details;

  PreviousSurgeries({
    required this.hasSurgeries,
    required this.details,
  });

  factory PreviousSurgeries.fromJson(Map<String, dynamic> json) {
    return PreviousSurgeries(
      hasSurgeries: json['hasSurgeries'] ?? false,
      details: json['details'] != null
          ? List<Surgery>.from(json['details']
              .map((x) => Surgery.fromJson(x))
              .where((surgery) => surgery != null))
          : [],
    );
  }
}

class Surgery {
  final String id;
  final String type;
  final DateTime? date;

  Surgery({
    required this.id,
    required this.type,
    this.date,
  });

  factory Surgery.fromJson(Map<String, dynamic> json) {
    // Check if type is meaningful before creating the Surgery object
    String type = json['type']?.toString().trim() ?? 'N/A';

    // If type is empty, return a default/empty Surgery
    if (type.isEmpty) {
      return Surgery(id: '', type: '', date: null);
    }

    return Surgery(
      id: json['_id'] ?? '',
      type: type,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}

class WomensHealth {
  final int totalBirths;
  final bool pregnancyComplications;

  WomensHealth({
    required this.totalBirths,
    required this.pregnancyComplications,
  });

  factory WomensHealth.fromJson(Map<String, dynamic> json) {
    return WomensHealth(
      totalBirths: json['totalBirths'] ?? 0,
      pregnancyComplications: json['pregnancyComplications'] ?? false,
    );
  }
}

class FamilyHistory {
  final bool alcoholism;
  final bool asthma;
  final bool cancer;
  final bool depressionAnxiety;
  final bool diabetes;
  final bool emphysema;
  final bool heartDisease;
  final bool hypertension;
  final bool highCholesterol;
  final bool thyroidDisease;
  final bool kidneyDisease;
  final bool migraineHeadaches;
  final bool stroke;
  final String other;

  FamilyHistory({
    required this.alcoholism,
    required this.asthma,
    required this.cancer,
    required this.depressionAnxiety,
    required this.diabetes,
    required this.emphysema,
    required this.heartDisease,
    required this.hypertension,
    required this.highCholesterol,
    required this.thyroidDisease,
    required this.kidneyDisease,
    required this.migraineHeadaches,
    required this.stroke,
    required this.other,
  });

  factory FamilyHistory.fromJson(Map<String, dynamic> json) {
    return FamilyHistory(
      alcoholism: json['alcoholism'] ?? false,
      asthma: json['asthma'] ?? false,
      cancer: json['cancer'] ?? false,
      depressionAnxiety: json['depressionAnxiety'] ?? false,
      diabetes: json['diabetes'] ?? false,
      emphysema: json['emphysema'] ?? false,
      heartDisease: json['heartDisease'] ?? false,
      hypertension: json['hypertension'] ?? false,
      highCholesterol: json['highCholesterol'] ?? false,
      thyroidDisease: json['thyroidDisease'] ?? false,
      kidneyDisease: json['kidneyDisease'] ?? false,
      migraineHeadaches: json['migraineHeadaches'] ?? false,
      stroke: json['stroke'] ?? false,
      other: json['other'] ?? '',
    );
  }
}
