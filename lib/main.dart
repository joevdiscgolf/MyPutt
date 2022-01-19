import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/record_putting/cubits/sessions_screen_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SessionsScreenCubit()),
      ],
      child: const MaterialApp(
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: MainWrapper(),
      ),
    );
  }
}
