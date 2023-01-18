import 'package:dating_now/src/core/bloc/app_blocs_provider.dart';
import 'package:dating_now/src/features/example/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/gen/assets.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            AppBlocs.homeBloc.add(TapImageEvent());
          },
          child: Center(
            child: Assets.images.imgGirl1.image(),
          ),
        ),
      ),
    );
  }
}