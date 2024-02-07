import 'package:get_it/get_it.dart';

import 'cubit/contact_cubit.dart';


final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerLazySingleton<ContactCubit>(
        () => ContactCubit(),
  );
}