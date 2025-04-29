import 'package:flutter/material.dart';
import 'package:untitled/components/common_post.dart';
import 'package:untitled/model/post_model_response.dart';

class PostDetailView extends StatelessWidget {
  final PostModelResponse post;
  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: CommonPost(post: post,),
      ),
    );
  }
}
