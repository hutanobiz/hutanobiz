import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
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
  ApiBaseHelper api = ApiBaseHelper();

  Image selected = Image.asset(
    'images/selectedStar.png',
    height: 40,
  );
  Image unselected = Image.asset(
    'images/unselectedStar.png',
    height: 40,
  );
  Image img1;
  Image img2;
  Image img3;
  Image img4;
  Image img5;
  int count = 0;
  List<bool> star = [false, false, false, false, false];
  final TextEditingController _reviewController = TextEditingController();
  Map rateMap = Map();
  bool _isLoading = false;
  final reviewText = TextEditingController();
  Future<List<dynamic>> _reasonsFuture;
  List _reasonList = [];

  @override
  void initState() {
    img1 = unselected;
    img2 = unselected;
    img3 = unselected;
    img4 = unselected;
    img5 = unselected;

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
    _reasonsFuture = api.getReviewReasons();
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
        title: "Rate Doctor",
        isAddBack: true,
        isLoading: _isLoading,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                // padding: const EdgeInsets.only(bottom: 70.0),
                shrinkWrap: true,
                //children: widgetList(),//_providerMap),
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'images/doctorImage.png',
                          height: 70,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Appointment Complete',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'How was your experience?',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          img1,
                          img2,
                          img3,
                          img4,
                          img5,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: FutureBuilder<List<dynamic>>(
                        future: _reasonsFuture,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> data = snapshot.data;
                            if (data == null || data.length == 0)
                              return Container();
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: data.length,
                              itemBuilder: (context, titleIndex) {
                                if (data == null || data.length == 0)
                                  return Container();
                                dynamic reason = data[titleIndex];
                                return CheckboxListTile(
                                  activeColor: AppColors.goldenTainoi,
                                  title: Text(reason['reason']),
                                  value: star[titleIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      changeStar(value, reason['reason']);
                                      star[titleIndex] = value;
                                    });
                                  },
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return LinearProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      controller: reviewText,
                      maxLines: 10,
                      autocorrect: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                child: FancyButton(
                  title: "Submit",
                  onPressed: (count >= 1 &&
                          (_reasonList != null && _reasonList.length > 0))
                      ? () {
                          rateMap["review"] = reviewText.toString();
                          rateMap["rating"] = count.toString();
                          FocusScope.of(context).requestFocus(FocusNode());

                          if (_reasonList != null || _reasonList.length > 0) {
                            for (var i = 0; i < _reasonList.length; i++) {
                              rateMap["reason[$i]"] = _reasonList[i];
                            }
                          }
                          setState(() => _isLoading = true);
                          SharedPref().getToken().then(
                            (token) {
                              api.rateDoctor(token, rateMap).then(
                                (response) {
                                  print(_reasonList);
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

  void changeStar(bool value, reason) {
    if (value == true) {
      count++;
      _reasonList.add(reason);
      switch (count) {
        case 1:
          {
            img1 = selected;
          }
          break;
        case 2:
          {
            img2 = selected;
          }
          break;

        case 3:
          {
            img3 = selected;
          }
          break;

        case 4:
          {
            img4 = selected;
          }
          break;

        case 5:
          {
            img5 = selected;
          }
          break;
      }
    } else {
      count--;
      switch (count) {
        case 0:
          {
            img1 = unselected;
          }
          break;
        case 1:
          {
            img2 = unselected;
          }
          break;

        case 2:
          {
            img3 = unselected;
          }
          break;

        case 3:
          {
            img4 = unselected;
          }
          break;

        case 4:
          {
            img5 = unselected;
          }
          break;
      }
    }
  }

  List<Widget> widgetList() {
    //Map _providerData) {
    List<Widget> widgetList = List();

    // widgetList.add(profileWidget(_providerData);

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
          RatingBar.builder(
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
      child: FutureBuilder<List<dynamic>>(
        future: _reasonsFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data;

            if (data == null || data.length == 0) return Container();

            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, titleIndex) {
                if (data == null || data.length == 0) return Container();

                dynamic reason = data[titleIndex];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CheckboxListTile(
                    title: Text(reason['reason']),
                    onChanged: (value) {
                      if (value &&
                          !_reasonList.contains(reason['_id'].toString())) {
                        _reasonList.add(reason['_id'].toString());
                      } else {
                        _reasonList.remove(reason['_id'].toString());
                      }

                      setState(() {});
                      _reasonList.toString().debugLog();
                    },
                    activeColor: AppColors.goldenTainoi,
                    value: _reasonList.contains(reason['_id'].toString()),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

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
            padding: const EdgeInsets.all(20),
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
                  "Thank You.\nWe value your feedback.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
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
