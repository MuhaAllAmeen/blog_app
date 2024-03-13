part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterID;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload(this.posterID, this.title, this.content, this.image, this.topics);
}

final class BlogGetAllBlogs extends BlogEvent{}

