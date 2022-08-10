import 'package:bloc_example/bloc/post/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'infinite_list_view.dart';

class InfiniteListPage extends StatelessWidget {
  const InfiniteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite List"),
      ),
      body: BlocProvider(
        create: (context) => PostBloc(httpClient: http.Client())
          ..add(
            const PostFetched(),
          ),
        child: const InfiniteListView(),
      ),
    );
  }
}
