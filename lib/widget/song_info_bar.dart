import 'package:cse_111ay_flutter_topic_demo/page/song_detail.dart';
import 'package:cse_111ay_flutter_topic_demo/service/audio_controller.dart';
import 'package:flutter/material.dart';

class SongInfoBar extends StatefulWidget {
  const SongInfoBar({
    Key? key
  }) : super(key: key);

  @override
  State<SongInfoBar> createState() => _SongInfoBarState();
}

class _SongInfoBarState extends State<SongInfoBar> {
  AudioController audioController = AudioController.instance;

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SongDetail(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        audioController.currentPlayingSongIndex,
        audioController.currentSongIsPlaying,
        audioController.currentPlayingSongProgress
      ]),
      builder: (BuildContext context, Widget? child) {
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          onTap: () async {
            await Navigator.of(context).push(_createRoute());
          },
          child: Container(
            height: 66,
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xff3f3f3f),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: (audioController.currentPlayingSongCoverSource == "") ?
                          Container(color: Colors.grey,) :
                          Image.network(audioController.currentPlayingSongCoverSource),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioController.currentPlayingSongTitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          audioController.currentPlayingSongAuthor,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          AudioController.formatDuration(audioController.currentPlayingSongProgress.value),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                        const Text(
                          " / ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey
                          ),
                        ),
                        Text(
                          AudioController.formatDuration(audioController.currentPlayingSongDuration),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8,),
                    InkWell(
                      onTap: () async {
                        if (audioController.currentSongIsPlaying.value) {
                          await audioController.pause();
                        } else {
                          await audioController.resume();
                        }
                      },
                      child: (audioController.currentSongIsPlaying.value) ?
                      const Icon(Icons.pause_rounded, size: 36,) :
                      const Icon(Icons.play_arrow_rounded, size: 36,),
                    ),
                    const SizedBox(width: 8,)
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Container(
                          color: Colors.grey,
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Container(
                          color: Colors.white,
                          height: 2,
                          width: (MediaQuery.of(context).size.width - 48) * (audioController.currentPlayingSongProgress.value / audioController.currentPlayingSongDuration),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}