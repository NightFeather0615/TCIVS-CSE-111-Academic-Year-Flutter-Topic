import 'package:cse_111ay_flutter_topic_demo/service/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthorPageInfoRow extends StatefulWidget {
  final int monthlyListener;

  const AuthorPageInfoRow({
    Key? key,
    required this.monthlyListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthorPageInfoRowState();
}

class _AuthorPageInfoRowState extends State<AuthorPageInfoRow> {
  AudioController audioController = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${NumberFormat('#,###', 'en_US').format(widget.monthlyListener)} monthly listeners",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                ),
              ),
              const SizedBox(height: 6,),
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {

                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.white,
                              width: 1.5
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                      child: const Text(
                        "Follow",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                  const Spacer(),
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {

                      },
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.shuffle_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                      )
                  ),
                  const SizedBox(width: 12,),
                  SizedBox(
                    width: 50,
                    height: 50,
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
                              const Color(0xff1fdf64)
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
                        scale: 2.2,
                        child: AnimatedBuilder(
                            animation: audioController.currentSongIsPlaying,
                            builder: (BuildContext context, Widget? child) {
                              return Icon(
                                (audioController.currentSongIsPlaying.value) ?
                                Icons.pause_rounded :
                                Icons.play_arrow_rounded,
                                size: 14,
                                color: Theme.of(context).backgroundColor,
                              );
                            }
                        )
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8,),
              const Text(
                "Popular",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        )
    );
  }
}