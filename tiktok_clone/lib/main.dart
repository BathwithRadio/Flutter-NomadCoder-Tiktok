import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/intl_generated.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
/**
 * Flutter Framework를 이용해 앱이 시작하기 전에 state를 어떤식으로든 바꾸고 싶다면
 * engine자체와 engine과 widget의 연결을 확실하기 초기화 시켜야한다.
 */
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    S.load(const Locale("en"));
    return VideoConfig(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: Typography.blackMountainView,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFFE9435A),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade50,
          ),
          // change theme on all over app
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          // turn off click highlight effect
          // highlightColor: Colors.transparent,
          // turn off splash effect on app
          splashColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade700,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          textTheme: Typography.whiteMountainView,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            surfaceTintColor: Colors.black,
            backgroundColor: Colors.grey.shade900,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          ),
          //해당 위젯은 위젯 트리 맨 위에서 정의된 값도 어디에서든 가져다 사용할 수 있다
          //이것이 아니라면 모든 위젯에 GoRoute를 통해서 전달해야 한다.
          primaryColor: const Color(0xFFE9435A),
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
