import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

class RateDoctorScreen extends StatefulWidget {
  RateDoctorScreen({Key key}) : super(key: key);

  @override
  _RateDoctorScreenState createState() => _RateDoctorScreenState();
}

class _RateDoctorScreenState extends State<RateDoctorScreen> {
  InheritedContainerState _container;
  Map _providerMap = Map();
  double _rating = 0;
  String _ratingText;
  bool _doctorFriendliness = false,
      _responseTime = false,
      _doctorAdvise = false,
      _easeOfScheduling = false,
      _staffFriendliness = false;

  ApiBaseHelper api = ApiBaseHelper();

  final TextEditingController _reviewController = TextEditingController();
  Map rateMap = Map();
  bool _isLoading = false;

  @override
  void initState() {
    _reviewController.addListener(() => setState(() {}));

    SharedPref().getToken().then((token) {
      api.profile(token, Map()).then((dynamic response) {
        setState(() {
          rateMap["user"] = response["response"]["_id"];
          rateMap["userType"] = response["response"]["type"].toString();
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
    _providerMap = _container.getProviderData();

    _ratingText =
        "How was your experience with ${_providerMap['providerData']["data"]["doctor"]["fullName"]}?";

    rateMap["appointment"] = _container.appointmentIdMap["appointmentId"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Rate Doctor",
        isAddBack: true,
        isLoading: _isLoading,
        color: AppColors.white_smoke,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 70.0),
                shrinkWrap: true,
                children: widgetList(_providerMap),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                child: FancyButton(
                  title: "Submit",
                  onPressed: rateMap.length >= 5
                      ? () {
                          List reasonList = List();
                          if (_doctorFriendliness) {
                            reasonList.add("1");
                          }
                          if (_responseTime) {
                            reasonList.add("2");
                          }
                          if (_doctorAdvise) {
                            reasonList.add("3");
                          }
                          if (_easeOfScheduling) {
                            reasonList.add("4");
                          }
                          if (_staffFriendliness) {
                            reasonList.add("5");
                          }

                          if (reasonList != null || reasonList.length > 0) {
                            for (var i = 0; i < reasonList.length; i++) {
                              rateMap["reason[$i]"] = reasonList[i];
                            }
                          }

                          setState(() => _isLoading = true);

                          SharedPref().getToken().then((token) {
                            api.rateDoctor(token, rateMap).then((response) {
                              setState(() => _isLoading = false);

                              Widgets.showToast(response.toString());

                              Widgets.showToast("Rated doctor successfully");
                            }).futureError((onError) {
                              setState(() => _isLoading = false);
                              onError.toString().debugLog();
                            });
                          });
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

  List<Widget> widgetList(Map _providerData) {
    List<Widget> widgetList = List();

    widgetList.add(profileWidget(_providerData));

    widgetList.add(rateWidget());

    widgetList.add(_rating.round() >= 1
        ? Text(
            _rating.round() >= 5
                ? "Tell us what went right"
                : "Tell us what went wrong",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          )
        : Container());

    widgetList.add(_rating.round() >= 1 ? _selectWrongWidget() : Container());

    widgetList.add(Text(
      "Leave a Review",
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
    String name = "---", avatar = "---", professionalTitle = "---";
    Map _dataMap = _providerData['providerData']["data"];

    if (_dataMap["doctor"] != null) {
      name = _dataMap["doctor"]["fullName"] ?? "---";
      avatar = _dataMap["doctor"]["avatar"];
    }

    if (_providerData["doctorData"] != null) {
      for (dynamic detail in _providerData["doctorData"]) {
        if (detail["averageRating"] != null) if (detail["professionalTitle"] !=
            null) {
          professionalTitle = detail["professionalTitle"]["title"] ?? "---";
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 62.0,
              height: 62.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(avatar == null || avatar == "null"
                      ? 'http://i.imgur.com/QSev0hg.jpg'
                      : (ApiBaseHelper.imageUrl + avatar)),
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
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      "ic_experience".imageIcon(height: 11, width: 11),
                      SizedBox(width: 4.0),
                      Text(
                        "---",
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
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 70.0,
                  height: 25.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.goldenTainoi.withOpacity(0.13),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Text(
                    professionalTitle,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.goldenTainoi.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget rateWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
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
          _rating.round() == 1
              ? "ic_one_rating".imageIcon(height: 55.0, width: 55.0)
              : _rating.round() == 2
                  ? "ic_two_rating".imageIcon(height: 55.0, width: 55.0)
                  : _rating.round() == 3
                      ? "ic_three_rating".imageIcon(height: 55.0, width: 55.0)
                      : _rating.round() == 4
                          ? "ic_four_rating"
                              .imageIcon(height: 55.0, width: 55.0)
                          : _rating.round() == 5
                              ? "ic_five_rating"
                                  .imageIcon(height: 55.0, width: 55.0)
                              : Container(),
          _rating.round() >= 1 ? SizedBox(height: 21.0) : Container(),
          Text(
            _ratingText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight:
                  _rating.round() >= 1 ? FontWeight.w700 : FontWeight.w600,
              fontSize: _rating.round() >= 1 ? 18.0 : 16.0,
            ),
          ),
          SizedBox(height: 22.0),
          RatingBar(
            initialRating: _rating,
            itemSize: 35.0,
            minRating: 1,
            itemPadding: const EdgeInsets.only(right: 24.0),
            itemCount: 5,
            glow: false,
            itemBuilder: (context, index) => Image(
              image: AssetImage(
                "images/ic_star_rating.png",
              ),
              color: AppColors.goldenTainoi,
            ),
            onRatingUpdate: (double rating) {
              setState(() {
                _rating = rating;
              });

              rateMap["rating"] = _rating.round().toString();

              switch (rating.round()) {
                case 1:
                  setState(() {
                    _ratingText = "Very Poor!!";
                  });
                  break;
                case 2:
                  setState(() {
                    _ratingText = "Below Average!!";
                  });
                  break;
                case 3:
                  setState(() {
                    _ratingText = "Average!!";
                  });
                  break;
                case 4:
                  setState(() {
                    _ratingText = "Good!!";
                  });
                  break;
                case 5:
                  setState(() {
                    _ratingText = "Excellent!!";
                  });
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _selectWrongWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300], width: 0.5),
      ),
      child: Column(
        children: <Widget>[
          selectWrongTypeWidget("Doctor Friendliness", _doctorFriendliness,
              (bool value) {
            setState(() => _doctorFriendliness = value);
          }),
          selectWrongTypeWidget("Response Time", _responseTime, (bool value) {
            setState(() => _responseTime = value);
          }),
          selectWrongTypeWidget("Doctor's Advise", _doctorAdvise, (bool value) {
            setState(() => _doctorAdvise = value);
          }),
          selectWrongTypeWidget("Ease of scheduling", _easeOfScheduling,
              (bool value) => setState(() => _easeOfScheduling = value)),
          selectWrongTypeWidget("Staff friendliness", _staffFriendliness,
              (bool value) => setState(() => _staffFriendliness = value)),
        ],
      ),
    );
  }

  Widget selectWrongTypeWidget(
      String title, bool isChecked, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CheckboxListTile(
        title: Text(title),
        onChanged: onChanged,
        activeColor: AppColors.goldenTainoi,
        value: isChecked,
      ),
    );
  }
}
