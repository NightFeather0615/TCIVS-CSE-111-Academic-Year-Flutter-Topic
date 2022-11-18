import 'package:cse_111ay_flutter_topic_demo/service/audio_controller.dart';
import 'package:flutter/material.dart';

class SongDetail extends StatefulWidget {
  const SongDetail({
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  AudioController audioController = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          audioController.currentPlayingSongIndex,
          audioController.currentSongIsPlaying,
          audioController.currentPlayingSongProgress
        ]),
        builder: (BuildContext context, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 10),
                child: Row(
                  children: [
                    InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 55,
                          ),
                        )
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Text(
                          "PLAYING FROM ARTIST",
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                        Text(
                          audioController.currentPlayingSongAuthor,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        hoverColor: Colors.transparent,
                        onTap: () {

                        },
                        child: const SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.menu_rounded,
                            size: 30,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 40
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: (audioController.currentPlayingSongCoverSource == "") ?
                    Container(color: Colors.grey,) :
                    Image.network(audioController.currentPlayingSongCoverSource),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioController.currentPlayingSongTitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22
                          ),
                        ),
                        Text(
                          audioController.currentPlayingSongAuthor,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                          ),
                        )
                      ],
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 20, 26, 0),
                child: SizedBox(
                  height: 10,
                  child: SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.white,
                      overlayColor: Colors.transparent,
                      activeTickMarkColor: Colors.transparent,
                      overlappingShapeStrokeColor: Colors.transparent,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5
                      ),
                      trackShape: const RoundedRectSliderTrackShape(),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: const Color(0xff5e5e5e).withOpacity(0.5),
                    ),
                    child: Slider(
                        value: audioController.currentPlayingSongProgress.value.toDouble(),
                        max: audioController.currentPlayingSongDuration.toDouble() + 1,
                        min: 0,
                        divisions: audioController.currentPlayingSongDuration,
                        onChanged: (value) async {
                          await audioController.seekTo(value.toInt());
                        }
                    ),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AudioController.formatDuration(audioController.currentPlayingSongProgress.value),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                    ),
                    Text(
                      AudioController.formatDuration(audioController.currentPlayingSongDuration),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {

                      },
                      iconSize: 34,
                      icon: const Icon(
                        Icons.shuffle_rounded,
                      ),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        await audioController.play((audioController.currentPlayingSongIndex.value - 1) % audioController.songQueue.length);
                      },
                      iconSize: 54,
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                      ),
                    ),
                    SizedBox(
                      width: 66,
                      height: 66,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (audioController.currentSongIsPlaying.value) {
                            await audioController.pause();
                          } else {
                            if (audioController.currentPlayingSongIndex.value == -1) {
                              await audioController.play(0);
                            } else {
                              await audioController.resume();
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).backgroundColor
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99.0),
                                )
                            )
                        ),
                        child: Transform.scale(
                            scale: 2.6,
                            child: AnimatedBuilder(
                                animation: audioController.currentSongIsPlaying,
                                builder: (BuildContext context, Widget? child) {
                                  return Icon(
                                    (audioController.currentSongIsPlaying.value) ?
                                    Icons.pause_rounded :
                                    Icons.play_arrow_rounded,
                                    size: 16,
                                    color: Theme.of(context).backgroundColor,
                                  );
                                }
                            )
                        ),
                      ),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        await audioController.play((audioController.currentPlayingSongIndex.value + 1) % audioController.songQueue.length);
                      },
                      iconSize: 54,
                      icon: const Icon(
                        Icons.skip_next_rounded,
                      ),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {

                      },
                      iconSize: 34,
                      icon: const Icon(
                        Icons.loop_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      )
    );
  }
}
