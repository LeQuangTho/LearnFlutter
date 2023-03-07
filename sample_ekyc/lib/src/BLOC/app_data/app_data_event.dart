part of 'app_data_bloc.dart';

@immutable
abstract class AppDataEvent {}

class AppDataSetupEvent extends AppDataEvent {
  final BuildContext context;
  AppDataSetupEvent({
    required this.context,
  });
}
