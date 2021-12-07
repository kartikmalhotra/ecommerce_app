class VideoListModel {
  late List<Data> data;

  VideoListModel({required this.data});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    data = <Data>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  late String videoUrl;
  late String name;
  late String caption;
  late String songName;
  late String profileImg;
  late String likes;
  late String comments;
  late String shares;
  late String albumImg;
  late bool isFavourate;

  Data({
    required this.videoUrl,
    required this.name,
    required this.caption,
    required this.songName,
    required this.profileImg,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.albumImg,
    required this.isFavourate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    videoUrl = json['videoUrl'];
    name = json['name'];
    caption = json['caption'];
    songName = json['songName'];
    profileImg = json['profileImg'];
    likes = json['likes'];
    comments = json['comments'];
    shares = json['shares'];
    albumImg = json['albumImg'];
    isFavourate = json['isFavourate'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoUrl'] = this.videoUrl;
    data['name'] = this.name;
    data['caption'] = this.caption;
    data['songName'] = this.songName;
    data['profileImg'] = this.profileImg;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['shares'] = this.shares;
    data['albumImg'] = this.albumImg;
    data['isFavourate'] = this.isFavourate;
    return data;
  }
}
