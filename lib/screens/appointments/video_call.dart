import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

const APP_ID = '1dba38a531814b9f823d4d1c4e0c9a89';

class CallPage extends StatefulWidget {
  final Map channelName;
  CallPage({Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool muted = false;
  bool mutedVideo = false;
  RtcEngine _engine;
  final _users = <int>[];
  final _infoStrings = <String>[];
  ClientRole role = ClientRole.Broadcaster;
  ApiBaseHelper api = ApiBaseHelper();
  int userId = 456;
  var resourceId = '';
  var sid = '';
  var token = '';
  var appid = '1dba38a531814b9f823d4d1c4e0c9a89';
  dynamic appointmentResponse;
  bool remoteAudio = true, remoteVideo = true;

  @override
  void dispose() {
    // clear users
    // _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((usertoken) {
      token = usertoken;
      api
          .getAppointmentDetails(
        token,
        widget.channelName['_id'],
        LatLng(0, 0),
      )
          .then((value) {
        appointmentResponse = value;
      });
    });
    mutedVideo = !widget.channelName['video'];
    // String plainCredentials =
    //     "a6ec51f4c7484224a81195e695a3ca17:5c927e729da145d98121b6abbbfe8317";
    // token = base64.encode(utf8.encode(plainCredentials));
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1280, 720);
    await _engine.setVideoEncoderConfiguration(configuration);
    // final key = Encrypt.Key.fromLength(32);
    // final iv = Encrypt.IV.fromLength(16);
    // final encrypter = Encrypt.Encrypter(Encrypt.AES(key));
    // final encrypted = encrypter.encrypt('12345', iv: iv);

    // EncryptionConfig encryptionConfig =
    //     EncryptionConfig(EncryptionMode.AES128ECB, encrypted.base64.toString());
    // await _engine.enableEncryption(true, encryptionConfig);
    _engine.muteLocalVideoStream(mutedVideo);
    _engine.enableLocalVideo(!mutedVideo);
    _engine
        .joinChannel(null, widget.channelName['_id'], null, userId)
        .then((value) {});
  }

  startCall() {
    var startMap = {};
    startMap['appointmentId'] = widget.channelName['_id'];
    startMap['appid'] = appid;
    api.startVideoCall(context, token, startMap).then((value) {
      print(value.toString());
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      // updateSubscriptionList();
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      //  updateSubscriptionList();
      setState(() {
        _infoStrings.add('onLeaveChannel');

        _users.clear();
      });
    }, userMuteAudio: (uid, muted) {
      setState(() {
        remoteAudio = !muted;
      });
    }, userMuteVideo: (uid, muted) {
      setState(() {
        remoteVideo = !muted;
      });
    }, userJoined: (uid, elapsed) {
      //aquire();
      //updateSubscriptionList();
      startCall();
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);

        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      // updateSubscriptionList();
      setState(() {
        final info = 'userOffline: $uid';
        showConfirmDialog();
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      //  updateSubscriptionList();
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  void _onCallEnd(BuildContext context) {
    var stopMap = {};
    stopMap['appid'] = appid;
    stopMap['appointmentId'] = widget.channelName['_id'];
    api.stopVideoCall(context, token, stopMap).then((value) {
      Navigator.pop(context);
      var appointmentCompleteMap = {};
      appointmentCompleteMap['type'] = '2';
      appointmentCompleteMap['appointmentId'] = widget.channelName['_id'];
      appointmentCompleteMap['name'] = appointmentResponse["data"]['doctor']
              ['title'] +
          ' ' +
          appointmentResponse["data"]['doctor']['fullName'];

      appointmentCompleteMap['avatar'] =
          appointmentResponse["data"]['doctor']['avatar'];
      appointmentCompleteMap["dateTime"] =
          DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
      Navigator.of(context).pushReplacementNamed(
        Routes.appointmentCompleteConfirmation,
        arguments: appointmentCompleteMap,
      );
    });
  }

  _onBlockCamera() {
    setState(() {
      mutedVideo = !mutedVideo;
    });

    //  mutedVideo? _engine.disableVideo():_engine.enableVideo();
    // _engine.muteLocalVideoStream(mutedVideo);
    _engine.muteLocalVideoStream(mutedVideo);
    _engine.enableLocalVideo(!mutedVideo);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
// muted? _engine.disableAudio():_engine.enableAudio();
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  _viewRows(),
                  // _panel(),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          remoteAudio
                              ? SizedBox()
                              : Expanded(
                                  child: Icon(
                                  Icons.mic_off,
                                  color: Colors.red,
                                  size: 48,
                                )),
                          remoteVideo
                              ? SizedBox()
                              : Expanded(
                                  child: Icon(Icons.videocam_off,
                                      color: Colors.red, size: 48)),
                        ],
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: RawMaterialButton(
                        onPressed: () {
                          Widgets.showConfirmationDialog(
                              context: context,
                              title: 'End Call',
                              description: 'Are you sure to end Call?',
                              leftText: 'No',
                              onLeftPressed: () {
                                Navigator.pop(context);
                              },
                              rightText: 'Yes',
                              onRightPressed: () {
                                Navigator.pop(context);
                                var appointmentCompleteMap = {};
                                appointmentCompleteMap['type'] = '2';
                                appointmentCompleteMap['appointmentId'] =
                                    widget.channelName['_id'];
                                appointmentCompleteMap['name'] =
                                    appointmentResponse["data"]['doctor']
                                            ['title'] +
                                        ' ' +
                                        appointmentResponse["data"]['doctor']
                                            ['fullName'];

                                appointmentCompleteMap['avatar'] =
                                    appointmentResponse["data"]['doctor']
                                        ['avatar'];
                                appointmentCompleteMap["dateTime"] =
                                    DateFormat('dd MMM yyyy, HH:mm')
                                        .format(DateTime.now());
                                Navigator.of(context).pushReplacementNamed(
                                  Routes.appointmentCompleteConfirmation,
                                  arguments: appointmentCompleteMap,
                                );
                              });
                        },
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.redAccent,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _toolbar()
          ],
        ),
      ),
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return mutedVideo
            ? Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Colors.black)),
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_off, color: Colors.red, size: 48),
                      Text('Please turn on your video',
                          style: TextStyle(color: Colors.red))
                    ],
                  )),
                ],
              )
            : _videoView(views[0]);
      case 2:
        return Container(
            child: Stack(
          children: <Widget>[
            remoteVideo
                ? _videoView(views[1])
                : Container(
                    color: Colors.black,
                  ),
            _myVideoView(views[0]),
          ],
        ));
      default:
    }
    return Container();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    // if (widget.role == ClientRole.Broadcaster) {
    list.add(RtcLocalView.SurfaceView());
    // }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: view);
  }

  Widget _myVideoView(view) {
    return Positioned(
        right: 20,
        top: 50,
        child: Container(
          height: 120,
          width: 80,
          child: mutedVideo
              ? Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.black)),
                    Center(
                        child: Icon(Icons.videocam_off,
                            color: Colors.red, size: 24)),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: view),
        ));
    // return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  // Widget _expandedVideoRow(List<Widget> views) {
  //   final wrappedViews = views.map<Widget>(_videoView).toList();
  //   return Expanded(
  //     child: Row(
  //       children: wrappedViews,
  //     ),
  //   );
  // }

  /// Toolbar layout
  Widget _toolbar() {
    if (role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          InkWell(
            onTap: _onBlockCamera,
            child: Image.asset(
              mutedVideo
                  ? 'images/video_disabled.png'
                  : 'images/video_enabled.png',
              height: 60.0,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: _onToggleMute,
            child: Image.asset(
              muted ? 'images/audio_disabled.png' : 'images/audio_enabled.png',
              height: 60.0,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: _onSwitchCamera,
            child: Image.asset(
              'images/change_camera.png',
              height: 60.0,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Confirm Treatment End',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Please confirm that the treatment is now complete.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 26),
                Row(
                  children: [
                    Spacer(),
                    FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            side: BorderSide(color: AppColors.windsor)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.windsor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Map<String, String> map = {};
                          map['appointmentId'] =
                              widget.channelName['_id'].toString();
                          api
                              .cancelCallEndNotification(token, map)
                              .then((value) {});
                          Navigator.pop(context);
                        }),
                    Spacer(),
                    FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: AppColors.windsor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          _onCallEnd(context);
                        }),
                    Spacer(),
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
