import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/activity_categorized_list.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/activty_temp.dart';
import 'screens/categorized_tags_listview.dart';
import 'screens/map_screen/map_screen.dart';
import 'screens/mood_categorized_entry_list_view.dart';
import 'screens/diary_writer_screen.dart';
import 'screens/edit_entry_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screens/auth_settings_screen.dart';
import 'screens/settings_screens/export_diary.dart';
import 'screens/settings_screens/settings_screen.dart';
import 'screens/tabs/tab_1_main/home_main_tab.dart';
import 'screens/auth/login_screen.dart';
import 'screens/view_entry_screen.dart';
import 'services/entry_data_service.dart';
import 'services/firestore_service.dart';
import 'services/gplace_services.dart';
import 'services/images_service.dart';
import 'services/location_service.dart';
import 'services/tag_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ImagesService>(
      create: (context) => ImagesService(),
    ),
    ChangeNotifierProvider<LocationService>(
      create: (context) => LocationService(),
    ),
    ChangeNotifierProvider<LocationService>(
      create: (context) => LocationService(),
    ),
    ChangeNotifierProvider<FirestoreService>(
      create: (context) => FirestoreService(),
    ),
    ChangeNotifierProvider<GooglePlaceService>(
      create: (context) => GooglePlaceService(),
    ),
    ChangeNotifierProvider<TagService>(
      create: (context) => TagService(),
    ),
    Provider<EntryBuilderService>(
      create: (context) => EntryBuilderService(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        SignUpPage.routeName: (ctx) => SignUpPage(),
        LoginPage.routeName: (ctx) => LoginPage(),
        DiaryWriterScreen.routeName: (ctx) => DiaryWriterScreen(),
        MainHomeScreen.routeName: (ctx) => MainHomeScreen(),
        ActivityRecognitionApp.routeName: (ctx) => ActivityRecognitionApp(),
        ViewEntryScreen.routeName: (ctx) => ViewEntryScreen(),
        EditEntryScreen.routeName: (ctx) => EditEntryScreen(),
        SearchBar.routeName: (ctx) => SearchBar(),
        MoodCategorizedEntryListView.routeName: (ctx) =>
            MoodCategorizedEntryListView(),
        ActivityCategorizedEntryListView.routeName: (ctx) =>
            ActivityCategorizedEntryListView(),
        TagsCategorizedListView.routeName: (ctx) => TagsCategorizedListView(),
        MapScreen.routeName: (ctx) => MapScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        ExportDiary.routeName: (ctx) => ExportDiary(),
        AuthSettings.routeName: (ctx)=> AuthSettings(),
      },
    );
  }
}
