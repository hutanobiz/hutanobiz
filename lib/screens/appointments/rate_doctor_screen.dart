import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/feedback_wdiget.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class RateDoctorScreen extends StatefulWidget {
  final String rateFrom;
  RateDoctorScreen({Key key, this.rateFrom}) : super(key: key);

  @override
  _RateDoctorScreenState createState() => _RateDoctorScreenState();
}

class _RateDoctorScreenState extends State<RateDoctorScreen> {
  InheritedContainerState _container;
  Map _providerMap = Map();
  double _rating = 0;
  String _ratingText, _name, avatar;
  List<bool> postiveFeedback = [false, false, false, false, false];
  ApiBaseHelper api = ApiBaseHelper();
  bool _ratingSelected =false;

  final TextEditingController _reviewController = TextEditingController();
  Map rateMap = Map();
  bool _isLoading = false;

  List _reasonList = [];

  @override
  void initState() {
    super.initState();

    _reviewController.addListener(() => setState(() {}));

    SharedPref().getToken().then((token) {
      api.profile(token, Map()).then((dynamic response) {
        setState(() {
          rateMap["user"] = response["response"]["_id"];
          rateMap["userType"] = response["response"]["type"].toString();
        });
      });
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
    _providerMap = _container.getProviderData();

    if (_reasonList.length == 0) {
      String id="";
      if(_providerMap['providerData']["data"] != null){
        id = _providerMap['providerData']['data']['doctor']['_id'];
      }else{
        id= _providerMap['providerData']['doctor']['_id'];
      }

      _reasonList = await api.getReviewReasons(id);
    }

    if (_providerMap['providerData']["data"] != null) {
      if (_providerMap['providerData']["data"]["doctor"] != null) {
        _name =
            _providerMap['providerData']["data"]["doctor"]["fullName"] ?? "---";
        avatar = _providerMap['providerData']["data"]["doctor"]["avatar"];
      }
    } else if (_providerMap['providerData'] != null) {
      if (_providerMap['providerData']["doctor"] != null) {
        _name = _providerMap['providerData']["doctor"]["fullName"] ?? "---";
        avatar = _providerMap['providerData']["doctor"]["avatar"];
      }
    }
    _ratingText = "How was your experience with $_name ?";

    rateMap["appointment"] = _container.appointmentIdMap["appointmentId"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Feedback",
        isAddBack: true,
        isLoading: _isLoading,
        color: AppColors.white_smoke,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              child: _reasonList.length > 0
                  ? ListView(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      shrinkWrap: true,
                      children: widgetList(_providerMap),
                    )
                  : Container(),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                child: FancyButton(
                  title: "Submit",
                  onPressed: (_ratingSelected)
                      ? () {
                          FocusScope.of(context).requestFocus(FocusNode());
                            int _count=0;
                          if (_reasonList != null || _reasonList.length > 0) {
                            for (var i = 0; i < _reasonList.length; i++) {
                              if (postiveFeedback[i]) {
                                rateMap["reason[$_count]"] = _reasonList[i]["_id"];
                                _count++;
                              }
                            }
                          }

                          rateMap["rating"] =_rating.toString();

                          setState(() => _isLoading = true);

                          SharedPref().getToken().then(
                            (token) {
                              api.rateDoctor(token, rateMap).then(
                                (response) {
                                  setState(() => _isLoading = false);

                                  showThankDialog();
                                },
                              ).futureError(
                                (onError) {
                                  setState(() => _isLoading = false);
                                  onError.toString().debugLog();
                                },
                              );
                            },
                          );
                        }
                      : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onChanged(int count, updatedFeedback) {
    _ratingSelected =true;
    setState(() {
      _rating = count.toDouble();
      postiveFeedback = updatedFeedback;
    });
  }

  List<Widget> widgetList(Map _providerData) {
    List<Widget> widgetList = List();

    widgetList.add(profileWidget(_providerData));

    widgetList.add(rateWidget());

    widgetList.add(SizedBox(
      height: 25,
    ));

    widgetList
        .add(FeedbackWidget(onChanged: _onChanged, quetions: _reasonList));

    // widgetList.add(_rating.round() >= 1
    //     ? Text(
    //         _rating.round() >= 5
    //             ? "Tell us what went right"
    //             : "Tell us what went wrong",
    //         style: TextStyle(
    //           fontSize: 14.0,
    //           fontWeight: FontWeight.w700,
    //         ),
    //       )
    //     : Container());

    // widgetList.add(_rating.round() >= 1 ? _selectWrongWidget() : Container());

    widgetList.add(SizedBox(height: 30));
    widgetList.add(Text(
      "Do you have any suggetions to improve your care next time ?",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
      ),
    ));

    widgetList.add(SizedBox(height: 14.0));

    widgetList.add(Container(
      height: 150.0,
      child: TextField(
        controller: _reviewController,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        textInputAction: TextInputAction.newline,
        onChanged: (text) {
          if (text.isNotEmpty)
            rateMap["review"] = text.toString();
          else
            rateMap.remove("review");
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Type something here...",
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
      ),
    ));

    return widgetList;
  }

  Widget profileWidget(Map _providerData) {
    String professionalTitle = "---", practisingSince = "---";
    Map _dataMap = _providerData['providerData'];

    if (_dataMap["doctorData"] != null) {
      for (dynamic detail in _dataMap["doctorData"]) {
        practisingSince = (detail["practicingSince"] != null
                ? (DateTime.now()
                            .difference(
                                DateTime.parse(detail["practicingSince"]))
                            .inDays /
                        366)
                    .toStringAsFixed(1)
                : "---") +
            " Years of Experience";

        if (detail["professionalTitle"] != null) {
          professionalTitle =
              detail["professionalTitle"]["title"]?.toString() ?? "---";
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 62.0,
              height: 62.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: avatar == null
                      ? AssetImage('images/profile_user.png')
                      : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.grey[300],
                  width: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    professionalTitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      "ic_experience".imageIcon(height: 11, width: 11),
                      SizedBox(width: 4.0),
                      Text(
                        practisingSince,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget rateWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300], width: 0.5),
      ),
      child: Column(
        children: <Widget>[
          RatingBar(
            initialRating: _rating,
            itemSize: 35.0,
            minRating: 1,
            itemPadding: const EdgeInsets.only(right: 17.0),
            itemCount: 5,
            glow: false,
            itemBuilder: (context, index) => Image(
              image: AssetImage(
                "images/ic_star_rating.png",
              ),
              color: AppColors.goldenTainoi,
            ),
            onRatingUpdate: (double rating) {
              
            },
          ),
        ],
      ),
    );
  }

  Widget showRatingBar() {
    return RatingBar(
      initialRating: _rating,
      itemSize: 32.0,
      minRating: 1,
      itemPadding: const EdgeInsets.only(right: 10.0),
      itemCount: 5,
      glow: false,
      itemBuilder: (context, index) => Image(
        image: AssetImage(
          "images/ic_star_rating.png",
        ),
        color: AppColors.goldenTainoi,
      ),
      onRatingUpdate: (double rating) {},
    );
  }

  // Widget _selectWrongWidget() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
  //     padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(14.0),
  //       ),
  //       border: Border.all(color: Colors.grey[300], width: 0.5),
  //     ),
  //     child: FutureBuilder<List<dynamic>>(
  //       future: _reasonsFuture,
  //       builder: (_, snapshot) {
  //         if (snapshot.hasData) {
  //           List<dynamic> data = snapshot.data;

  //           if (data == null || data.length == 0) return Container();

  //           return ListView.builder(
  //             shrinkWrap: true,
  //             physics: ScrollPhysics(),
  //             padding: EdgeInsets.zero,
  //             itemCount: data.length,
  //             itemBuilder: (context, titleIndex) {
  //               if (data == null || data.length == 0) return Container();

  //               dynamic reason = data[titleIndex];

  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 10.0),
  //                 child: CheckboxListTile(
  //                   title: Text(reason['reason']),
  //                   onChanged: (value) {
  //                     if (value &&
  //                         !_reasonList.contains(reason['_id'].toString())) {
  //                       _reasonList.add(reason['_id'].toString());
  //                     } else {
  //                       _reasonList.remove(reason['_id'].toString());
  //                     }

  //                     setState(() {});
  //                     _reasonList.toString().debugLog();
  //                   },
  //                   activeColor: AppColors.goldenTainoi,
  //                   value: _reasonList.contains(reason['_id'].toString()),
  //                 ),
  //               );
  //             },
  //           );
  //         } else if (snapshot.hasError) {
  //           return Text("${snapshot.error}");
  //         }
  //         return Center(
  //           child: CustomLoader(),
  //         );
  //       },
  //     ),
  //   );
  // }

  void showThankDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                "ic_feedback_done".imageIcon(
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 15),
                Text(
                  "Thank You For Your Feedback.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You Rated $_name",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                showRatingBar(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "We value your feedback.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                FlatButton(
                    color: AppColors.goldenTainoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      int count = 0;
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (widget.rateFrom != null) {
                        switch (widget.rateFrom) {
                          case "1":
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                            break;
                          case "2":
                            Navigator.of(context).popUntil(
                              ModalRoute.withName(
                                  Routes.appointmentDetailScreen),
                            );
                            break;
                          case "3":
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.dashboardScreen,
                              (Route<dynamic> route) => false,
                              arguments: true,
                            );
                            break;
                        }
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
