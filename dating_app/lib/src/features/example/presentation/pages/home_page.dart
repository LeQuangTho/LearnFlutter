import 'package:dating_now/src/core/app_common_widgets/buttons/button_primary.dart';
import 'package:dating_now/src/core/app_common_widgets/buttons/button_primary_icon.dart';
import 'package:dating_now/src/core/core.dart';
import 'package:dating_now/src/features/example/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.w5,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.icCards.svg(),
            label: '',
            activeIcon: Assets.icons.icCards.svg(color: AppColors.red),
          ),
          BottomNavigationBarItem(
              icon: Assets.icons.icDicator.svg(), label: ''),
          BottomNavigationBarItem(
            icon: Assets.icons.icMessage.svg(),
            label: '',
          ),
          BottomNavigationBarItem(icon: Assets.icons.icPeople.svg(), label: ''),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonPrimaryIcon(
                    icon: Assets.icons.icFacebook.svg(),
                    onTap: () {
                      AppBlocs.homeBloc.add(TapImageEvent());
                    },
                  ),
                  ButtonPrimaryIcon(
                    icon: Assets.icons.icGoogle.svg(),
                    onTap: () {
                      AppBlocs.homeBloc.add(TapImageEvent());
                    },
                  ),
                  ButtonPrimaryIcon(
                    icon: Assets.icons.icApple.svg(),
                    onTap: () {
                      AppBlocs.homeBloc.add(TapImageEvent());
                    },
                  ),
                ],
              ),
              ButtonPrimary(
                content: 'Access to a contact list',
                onTap: () {
                  AppBlocs.homeBloc.add(TapImageEvent());
                },
              ),
              ButtonPrimary(
                content: 'Use phone number',
                type: TypeButtonPrimary.border,
                onTap: () {
                  AppBlocs.homeBloc.add(TapImageEvent());
                },
              ),
              ButtonPrimary(
                content: 'Keep swiping',
                type: TypeButtonPrimary.light,
                onTap: () {
                  AppBlocs.homeBloc.add(TapImageEvent());
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {},
                    child: Assets.icons.icLike.svg(
                      height: 51.w,
                      width: 51.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
