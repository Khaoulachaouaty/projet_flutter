import 'package:flutter/material.dart';

enum PostType { text, image, video, pdf, mixed }

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final List<String> mediaUrls;
  final PostType type;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;

  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    this.mediaUrls = const [],
    this.type = PostType.text,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isSaved = false,
  });

  PostModel copyWith({
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostModel(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      mediaUrls: mediaUrls,
      type: type,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}