import 'package:flutter/material.dart';

class AuthorPageAppBar extends StatefulWidget {
  final String appBarImageSource;

  const AuthorPageAppBar({
    Key? key,
    required this.appBarImageSource
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthorPageAppBarState();
}

class _AuthorPageAppBarState extends State<AuthorPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          expandedTitleScale: 2.5,
          title: const Text(
            "結束バンド",
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
          ),
          background: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8)
                  ],
                  stops: const [
                    0.4,
                    0.75
                  ]
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Image.network(
              widget.appBarImageSource,
              fit: BoxFit.cover,
            ),
          )
      ),
    );
  }
}