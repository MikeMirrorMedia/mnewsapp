import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/blocs/config/bloc.dart';
import 'package:tv/blocs/config/events.dart';
import 'package:tv/blocs/config/states.dart';
import 'package:tv/pages/configPage.dart';
import 'package:tv/pages/homePage.dart';

class InitialApp extends StatefulWidget {
  @override
  _InitialAppState createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> {  
  @override
  void initState() {
    _loadingConfig();
    super.initState();
  }

  _loadingConfig() async{
    context.read<ConfigBloc>().add(ConfigEvents.loadingConfig);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (BuildContext context, ConfigState state) {
        if (state is ConfigError) {
          final error = state.error;
          String message = '${error.message}\nTap to Retry.';
          return Center(
            child: Text(message),
          );
        }
        if (state is ConfigLoaded) {
          return HomePage();
        }

        // state is Init, loading, or other 
        return ConfigPage();
      }
    );
  }
}