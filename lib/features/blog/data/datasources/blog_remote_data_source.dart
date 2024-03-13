import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blogModel,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blogModel.toMap()).select();
      print(BlogModel.fromMap(blogData.first));
      return BlogModel.fromMap(blogData.first);
    } catch (e) {
            print('fg ${e.toString()}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blogModel.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blogModel.id);
    } catch (e) {
            print('gg ${e.toString()}');

      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<List<BlogModel>> getAllBlogs() async{
    try{
    final blogs = await supabaseClient.from('blogs').select('*,profiles(name)');
    return blogs.map((blog) => BlogModel.fromMap(blog).copyWith(posterName: blog['profiles']['name'])).toList();
    }catch(e){
      throw ServerException(e.toString());
    }  
  }
}
