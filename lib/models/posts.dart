
class Post {
  final String postId;
  final String username;
  final String? userPfp;
  final String postDate;
  final String title;
  final String? desc;
  final List<dynamic>? images;
  final Map<String, Map<String, String>>? comments;
  final int? totalShare;
  final int? totalLike;

  Post({
    required this.postId,
    required this.username,
    required this.userPfp,
    required this.postDate,
    required this.title,
    required this.desc,
    required this.images,
    required this.comments,
    required this.totalShare,
    required this.totalLike,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'] as String,
      username: json['username'] as String,
      userPfp: json['user_pfp'] as String?,
      postDate: json['post_date'] as String,
      title: json['title'] as String,
      desc: json['desc'] as String?,
      images: (json['images'] as List<dynamic>?),
      comments: (json['comments'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, Map<String, String>.from(value))),
      totalShare: json['total_share'] as int?,
      totalLike: json['total_like'] as int?,
    );
  }
}
