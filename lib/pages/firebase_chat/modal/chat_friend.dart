class ChatProfile {
  final name;
  final email;
  final uid;
  final status;
  final image;
  final identity;
  final token;

  ChatProfile(
      {this.uid,
      this.name,
      this.email,
      this.status,
      this.image,
      this.identity,
      this.token});

  factory ChatProfile.fromJson(Map<dynamic, dynamic> json) {
    return ChatProfile(
        uid: json['uid'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        status: json['status'] ?? 'Welcome to AeroMeet',
        image: json['image'] ?? null,
        token: json['token'] ?? null,
        identity: json['identity'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final data = {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'status': this.status,
      'image': this.image,
      'token': this.token,
      'identity': this.identity,
    };
    return data;
  }
}
