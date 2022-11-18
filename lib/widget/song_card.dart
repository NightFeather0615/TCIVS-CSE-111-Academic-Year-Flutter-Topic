import 'package:cse_111ay_flutter_topic_demo/service/audio_controller.dart';
import 'package:flutter/material.dart';

class SongCard extends StatefulWidget {
  final int index;
  final String coverSource;
  final String audioSource;
  final String title;
  final String author;
  final int duration;

  const SongCard({
    Key? key,
    required this.index,
    required this.coverSource,
    required this.audioSource,
    required this.title,
    required this.author,
    required this.duration
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  bool _isHovered = false;
  AudioController audioController = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          audioController.currentPlayingSongIndex,
          audioController.currentSongIsPlaying
        ]),
        builder: (BuildContext context, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 10
            ),
            child: SizedBox(
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: () async {
                  if (audioController.currentPlayingSongIndex.value != widget.index) {
                    await audioController.play(widget.index);
                  } else {
                    if (audioController.currentSongIsPlaying.value) {
                      await audioController.pause();
                    } else {
                      await audioController.resume();
                    }
                  }
                },
                onHover: (isHovering) {
                  setState(() {
                    _isHovered = isHovering;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: (_isHovered) ?
                        (audioController.currentPlayingSongIndex.value == widget.index && audioController.currentSongIsPlaying.value) ?
                        const Icon(
                          Icons.pause_rounded,
                          size: 30,
                        ) : const Icon(
                          Icons.play_arrow_rounded,
                          size: 30,
                        ) : Text(
                          (widget.index + 1).toString(),
                          style: TextStyle(
                            color: (audioController.currentPlayingSongIndex.value == widget.index) ?
                            const Color(0xff1db954) :
                            Colors.grey,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(widget.coverSource),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: (audioController.currentPlayingSongIndex.value == widget.index) ?
                                  const Color(0xff1db954) :
                                  Colors.white,
                                  fontSize: 18
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.author,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        AudioController.formatDuration(widget.duration),
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        );
  }
}

