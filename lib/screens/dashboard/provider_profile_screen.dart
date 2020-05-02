import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/review_widget.dart';

class ProviderProfileScreen extends StatefulWidget {
  ProviderProfileScreen({Key key}) : super(key: key);

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  Future<dynamic> _profileFuture;
  Map _containerMap;
  InheritedContainerState _container;
  Map profileMap = Map();
  Map profileMapResponse = Map();
  String degree;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    Map _providerData = _container.providerIdMap;
    _containerMap = _container.getProjectsResponse();

    ApiBaseHelper api = ApiBaseHelper();

    _profileFuture = api.getProviderProfile(_providerData["providerId"]);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Provider Profile",
        color: AppColors.snow,
        isAddBack: false,
        addBackButton: true,
        buttonColor: AppColors.windsor,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: FutureBuilder(
                  future: _profileFuture,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("NO data available");
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List response = snapshot.data["data"];

                          profileMapResponse = snapshot.data;

                          if (response.isEmpty) return Container();

                          response.map((f) {
                            profileMap.addAll(f);
                          }).toList();

                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widgetList(profileMap),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        break;
                    }
                    return null;
                  }),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                child: FancyButton(
                  title: "Send Office Request",
                  buttonIcon: "ic_send_request",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    _container.getProviderData().clear();

                    _container.setProviderData(
                        "providerData", profileMapResponse);
                    _container.setProviderData("degree", degree);

                    if (_containerMap.containsKey("specialityId") ||
                        _containerMap.containsKey("serviceId"))
                      Navigator.of(context)
                          .pushNamed(Routes.appointmentTypeScreen);
                    else
                      Navigator.of(context)
                          .pushNamed(Routes.selectServicesScreen);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList(Map _providerData) {
    String institute;

    for (dynamic education in _providerData["education"]) {
      institute = education["institute"] ?? "---";
      degree = education["degree"] ?? "---";
    }

    List<Widget> formWidget = List();

    formWidget.add(ProviderWidget(
      data: _providerData,
      degree: degree.toString(),
      isOptionsShow: false,
    ));

    formWidget.add(SizedBox(height: 10.0));

    formWidget.add(Text(
      "About ${_providerData["userId"]["fullName"]}",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      Text(
        _providerData['about'] ?? "---",
        style: TextStyle(
          fontSize: 13.0,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 26.0));

    formWidget.add(
      Text(
        "Education",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      Text(
        "$institute, ${degree.toString()}",
        style: TextStyle(
          fontSize: 13.0,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 26.0));

    formWidget.add(
      Text(
        "Language Known",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.windsor.withOpacity(0.05),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          _providerData["userId"]["language"] ?? "---",
          style: TextStyle(
            color: AppColors.windsor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(SizedBox(height: 42.0));

    formWidget.add(
      Text(
        "Care by ${_providerData["userId"]["fullName"]}",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(Row(
      children: <Widget>[
        _providerData["isOfficeEnabled"]
            ? appoCard(
                'images/office_appointment.png',
                "Office\nAppointment",
              )
            : Container(),
        SizedBox(width: 20),
        _providerData["isVideoChatEnabled"]
            ? appoCard(
                'images/video_chat_appointment.png',
                "Video\nAppointment",
              )
            : Container()
      ],
    ));

    formWidget.add(SizedBox(height: 14.0));

    formWidget.add(
      _providerData["isOnsiteEnabled"]
          ? appoCard(
              'images/onsite_appointment.png',
              "Onsite\nAppointment",
            )
          : Container(),
    );

    formWidget.add(SizedBox(height: 42.0));

    formWidget.add(
      Text(
        "Feedback for ${_providerData["userId"]["fullName"]}",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    formWidget.add(SizedBox(height: 16.0));

    formWidget.add(Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(14.0),
      color: AppColors.goldenTainoi.withOpacity(0.06),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Overall Rating '),
                  TextSpan(
                      text: '5.0',
                      style: TextStyle(
                        color: AppColors.goldenTainoi,
                        fontWeight: FontWeight.w600,
                      )),
                ]),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: RatingBar(
                initialRating: 3,
                itemSize: 20.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: null,
              ),
            ),
          )
        ],
      ),
    ));

    formWidget.add(SizedBox(height: 20.0));

    formWidget.add(
      ReviewWidget(
        reviewerName: "Chris Hemsworth",
        reviewDate: "03 Dec 2019",
        reviewerRating: 5.0,
        reviewText:
            "Ann is one of the best nurses I have ever encountered.She has a great sense of humor: but she is very compassionate and serious about her work. I will definitely seek her out next time I need care.",
      ),
    );

    return formWidget;
  }

  Widget appoCard(String image, cardText) {
    return Container(
      width: 160.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(image),
            height: 54.0,
            width: 54.0,
          ),
          SizedBox(width: 12.0),
          Text(
            cardText,
            maxLines: 2,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
