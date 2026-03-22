import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/connectivity_service.dart';
import 'data/services/api_service.dart';
import 'data/repositories/track_repository.dart';
import 'presentation/blocs/library/library_bloc.dart';
import 'presentation/blocs/library/library_event.dart';
import 'presentation/screens/library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ConnectivityService()),
        RepositoryProvider(create: (context) => ApiService()),
        RepositoryProvider(
          create: (context) => TrackRepository(
            apiService: context.read<ApiService>(),
            connectivityService: context.read<ConnectivityService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LibraryBloc(
              trackRepository: context.read<TrackRepository>(),
            )..add(LoadTracksEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'Music Library',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const LibraryScreen(),
        ),
      ),
    );
  }
}
