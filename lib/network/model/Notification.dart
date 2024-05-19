class Notificationn {
  String Id;
  String CreatedAt;
  String To;
  String From;
  String Title;
  String Description;
  bool IsInformation;
  String? IdForDirect;
  bool? IsRead;

  Notificationn(
      {required this.Id,
      required this.CreatedAt,
      required this.To,
      required this.From,
      required this.Title,
      required this.Description,
      required this.IsInformation,
      required this.IdForDirect,
      required this.IsRead});

  factory Notificationn.fromJson(Map<String, dynamic> json) {
    return Notificationn(
        Id: json['id'],
        CreatedAt: json['createdAt'],
        To: json['to'],
        From: json['from'],
        Title: json['title'],
        Description: json['description'],
        IsInformation: json['isInformation'],
        IdForDirect: json['idForDirect'],
        IsRead: json['isRead']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'createdAt': CreatedAt,
      'to': To,
      'from': From,
      'title': Title,
      'description': Description,
      'isInformation': IsInformation,
      'idForDirect': IdForDirect,
      'isRead': IsRead,
    };
  }
}
