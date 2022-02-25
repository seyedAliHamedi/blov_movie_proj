import 'package:bloc_movie_proj/models/video.dart';

class VideoResponse {
  final List<Video> videos;
  final String error;

  const VideoResponse(this.videos, this.error);
  VideoResponse.fromJson(Map<String, dynamic> json)
      : videos = (json["results"] as List)
            .map((item) => Video.fromJson(item))
            .toList(),
        error = "";
  VideoResponse.withError(String errorValue)
      : videos = [],
        error = errorValue;
}
