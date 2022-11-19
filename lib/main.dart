import 'dart:convert';
import 'package:cse_111ay_flutter_topic_demo/service/audio_controller.dart';
import 'package:cse_111ay_flutter_topic_demo/widget/author_page_app_bar.dart';
import 'package:cse_111ay_flutter_topic_demo/widget/author_page_info_row.dart';
import 'package:cse_111ay_flutter_topic_demo/widget/song_card.dart';
import 'package:cse_111ay_flutter_topic_demo/widget/song_info_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCIVS CSE 111 Academic Year Flutter Topic',
      theme: ThemeData(
          colorSchemeSeed: Colors.black,
          brightness: Brightness.dark,
          canvasColor: Colors.transparent,
          indicatorColor: Colors.blueGrey.shade800,
          cardColor: Colors.blueGrey.shade900,
          secondaryHeaderColor: Colors.grey.shade500,
          progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Colors.blueGrey.shade800
          ),
          chipTheme: ChipThemeData(
              backgroundColor: Colors.blueGrey.shade700
          ),
          radioTheme: RadioThemeData(
            overlayColor: MaterialStateProperty.all(Colors.blueGrey.shade800),
            fillColor: MaterialStateProperty.all(
              Colors.white,
            ),
          ),
          useMaterial3: true
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioController audioController = AudioController.instance;
  List<SongData> songData = [];

  Future<Map<String, dynamic>> fetchData(String name) async {
    http.Response data = await http.get(Uri.parse("https://spotify-demo-functions.netlify.app/.netlify/functions/get-data-by-name?name=$name"));
    return jsonDecode(data.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: fetchData("結束バンド"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              songData.clear();
              for (var element in (snapshot.data["songs"] as List<dynamic>)) {
                songData.add(SongData.fromJson(element));
              }
              audioController.setSongQueue(songData);
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      AuthorPageAppBar(appBarImageSource: snapshot.data["app_bar_image_source"],),
                      AuthorPageInfoRow(monthlyListener: snapshot.data["monthly_listener"],),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: audioController.songQueue.length,
                              (context, index) {
                            return SongCard(
                                index: index,
                                coverSource: songData[index].coverSource,
                                audioSource: songData[index].audioSource,
                                title: songData[index].title,
                                author: songData[index].author,
                                duration: songData[index].duration
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 80,
                        ),
                      )
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0),
                                    Colors.black.withOpacity(1)
                                  ],
                                  stops: const [
                                    0,
                                    1
                                  ]
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstOut,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 90,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const SongInfoBar()
                        ],
                      )
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}