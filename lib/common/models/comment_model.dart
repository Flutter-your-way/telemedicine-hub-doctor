class CommentModel {
  final String? id;
  final String? ticket;
  final String? user;
  final String? patient;
  final String? fileKey;
  final String? fileUrl;
  final String? doctor;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommentModel({
    this.id,
    this.ticket,
    this.user,
    this.patient,
    this.fileKey,
    this.fileUrl,
    this.doctor,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      ticket: json['ticket'],
      user: json['user'],
      patient: json['patient'],
      fileKey: json['fileKey'],
      fileUrl: json['fileUrl'],
      doctor: json['doctor'],
      message: json['message'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert CommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ticket': ticket,
      'user': user,
      'patient': patient,
      'fileKey': fileKey,
      'fileUrl': fileUrl,
      'doctor': doctor,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
