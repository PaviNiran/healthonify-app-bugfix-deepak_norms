class WmConsultation {
  String? id;
  List<dynamic>? expert;
  String? startDate;
  String? startTime;
  List<dynamic>? userId;
  int? durationInMinutes;
  String? status;
  String? type;

  WmConsultation(
      { this.id,
      this.expert,
      this.startDate,
      this.startTime,
      this.userId,
      this.durationInMinutes,
      this.status,
      this.type});
}
