import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';

class SavedCardsScreen extends StatefulWidget {
  SavedCardsScreen({Key key}) : super(key: key);

  @override
  _SavedCardsScreenState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  ApiBaseHelper _api = ApiBaseHelper();

  Future<dynamic> _requestsFuture;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = _api.userAppointments(token);
        //TODO: change api
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Saved Cards",
        addBackButton: true,
        isAddBack: false,
        color: Colors.white,
        // child: paymentCard(
        //   "**** ***** **** 2563",
        //   "Dummy name",
        // ),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder<dynamic>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is String) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            List<dynamic> _cardsList = snapshot.data["data"];

            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _listWidget(_cardsList),
                  ]),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _listWidget(List<dynamic> _list) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        if (_list == null || _list.length == 0) return Container();

        return paymentCard(
          "**** ***** **** 2563",
          "Dummy name",
          "10/24",
        );
      },
    );
  }

  Widget paymentCard(
      String cardNumber, String cardHolderName, String expiryDate) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              "ic_dummy_card".imageIcon(width: 70, height: 70),
              SizedBox(width: 17.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cardNumber,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    cardHolderName,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Expires $expiryDate",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              button(
                "Edit",
                () {},
              ),
              SizedBox(width: 16.0),
              button(
                "Remove",
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget button(String title, Function onPressed) {
    return Expanded(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: Colors.grey[50],
        splashColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(width: 0.3, color: Colors.grey[300]),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}