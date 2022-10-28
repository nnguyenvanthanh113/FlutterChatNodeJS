class Message {
  String message;
  String sentByMe;

  Message({required this.message, required this.sentByMe});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(message: json["message"], sentByMe: json["sentByMe"]);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['message'] = this.message;
  //   data['sentMyMe'] = this.sentMyMe;
  //   return data;
  // }
}
