import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  SamplePlayer({Key key,this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network('https://hutano-video.s3-us-west-1.amazonaws.com/directory1/directory2/dd07c3a99c42ab3a30d8ec880d3a74e4_5f9b8507724c2711aea6554f.m3u8'),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager
      ),
    );
  }
}