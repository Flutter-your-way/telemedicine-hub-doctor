class TicketCountsModel {
  final int draft;
  final int pending;
  final int completed;
  final int cancelled;
  final int forwarded;
  final int total;

  TicketCountsModel({
    required this.draft,
    required this.pending,
    required this.completed,
    required this.cancelled,
    required this.forwarded,
    required this.total,
  });

  factory TicketCountsModel.fromJson(Map<String, dynamic> json) {
    return TicketCountsModel(
      draft: json['draft'] ?? 0,
      pending: json['pending'] ?? 0,
      completed: json['completed'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      forwarded: json['forwarded'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
