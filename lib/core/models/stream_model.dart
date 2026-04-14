class StreamModel {
  final String id;
  final String title;
  final String streamerName;
  final String thumbnailUrl;
  final int viewerCount;
  final String uid;
  final bool isLive;

  const StreamModel({
    required this.id,
    required this.title,
    required this.streamerName,
    required this.thumbnailUrl,
    required this.viewerCount,
    required this.uid,
    required this.isLive,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      streamerName: json['streamerName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      viewerCount: json['viewerCount'] ?? 0,
      uid: json['uid'] ?? '',
      isLive: json['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'streamerName': streamerName,
      'thumbnailUrl': thumbnailUrl,
      'viewerCount': viewerCount,
      'uid': uid,
      'isLive': isLive,
    };
  }
}
