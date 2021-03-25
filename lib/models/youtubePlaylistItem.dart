import 'package:tv/helpers/apiConstants.dart';

class YoutubePlaylistItem {
  final String youtubeVideoId;
  final String name;
  final String photoUrl;

  YoutubePlaylistItem({
    this.youtubeVideoId,
    this.name,
    this.photoUrl,
  });

  factory YoutubePlaylistItem.fromJson(Map<String, dynamic> json) {
    String photoUrl = mirrorNewsDefaultImageUrl;
    if (json['snippet'] != null && 
      json['snippet']['thumbnails'] != null &&
      json['snippet']['thumbnails']['high'] != null &&
      json['snippet']['thumbnails']['high']['url'] != null) {
      photoUrl = json['snippet']['thumbnails']['high']['url'];
    }

    return YoutubePlaylistItem(
      youtubeVideoId: json['snippet']['resourceId']['videoId'],
      name: json['snippet']['title'],
      photoUrl: photoUrl,
    );
  }
} 