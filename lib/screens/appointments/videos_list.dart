import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/video_player.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';

class VideoListScreen extends StatefulWidget {
  VideoListScreen({Key key, this.appointmentId}) : super(key: key);
  final String appointmentId;

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  ApiBaseHelper api = ApiBaseHelper();
  Future<dynamic> _requestsInsurnace;
  List<dynamic> _responseData = List();
  dynamic response;
  bool isInitialLoad = true;
  bool isLoading = false;

  @override
  void initState() {
    SharedPref().getToken().then((token) {
      setState(() {
        _requestsInsurnace =
            api.getAppointmentRecordings(context, token, widget.appointmentId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Videos",
        color: AppColors.snow,
        isAddBack: true,
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FutureBuilder<dynamic>(
          future: _requestsInsurnace,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (isInitialLoad) {
                response = snapshot.data;
                isInitialLoad = false;
              }
              if (response is String) {
                return Center(child: Text(response));
              } else {
                _responseData = response;
                return _listWidget(_responseData);
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _listWidget(List _responseData) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _responseData.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              border: Border.all(color: Colors.grey[300])),
          child: InkWell(onTap: (){
             Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SamplePlayer(videoPath: _responseData[index]['videoLink'],),
                            ),
                          );
          },
                      child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.video_collection),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _responseData[index]['_id'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 20,
        );
      },
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
