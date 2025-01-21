import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YT_Player extends StatefulWidget {
  final String ytUrl;

  const YT_Player({Key? key, required this.ytUrl}) : super(key: key);

  @override
  State<YT_Player> createState() => _YT_PlayerState();
}

class _YT_PlayerState extends State<YT_Player> {
  late YoutubePlayerController _ytController;
  late String videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.ytUrl)!;
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Color(0xFF4C2659),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 15,
              right: 0,
              child: Text(
                'E-Learning videos',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.88 - 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical:MediaQuery.of(context).size.height * 0.03
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        YoutubePlayer(controller: _ytController),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
