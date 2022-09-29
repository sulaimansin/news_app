
import 'package:mm/shared/cubit/cubit.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates{}

class AppCreateDatabase extends AppStates{}

class AppGetDatabase extends AppStates{}

class AppUpdateDatabase extends AppStates{}

class AppDeleteDatabase extends AppStates{}

class AppGetDatabaseLoadingState extends AppStates{}

class AppInsertDatabase extends AppStates{}

class AppChangeBottomSheetState extends AppStates{}


class AppChangeModeState extends AppStates{}


