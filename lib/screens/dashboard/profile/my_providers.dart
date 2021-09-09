import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/utils/extensions.dart';

class MyProviders extends StatefulWidget {
  MyProviders({Key key}) : super(key: key);

  @override
  _MyProvidersState createState() => _MyProvidersState();
}

class _MyProvidersState extends State<MyProviders> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;

  Future<List<dynamic>> _addressesFuture;

  String _token;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      _token = token;
      setState(() {
        _addressesFuture = api.getSavedDoctors(token, LatLng(0, 0), '100');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "My Providers",
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        isAddBack: true,
        isAddAppBar: true,
        addBottomArrows: false,
        isLoading: isLoading,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder<List<dynamic>>(
      future: _addressesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null ||
              snapshot.data.isEmpty ||
              snapshot.data is String) {
            return Center(
              child: Text('No providers.'),
            );
          }

          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: AppColors.haiti.withOpacity(0.20),
                  ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return providerWidget(context, snapshot.data[index]);
              });
        } else if (snapshot.hasError) {
          return Text('No providers.');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container providerWidget(BuildContext context, dynamic provider) {
    var practicingSince = provider['experience'].toString() ?? '';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.grey[200],
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pushNamed(
                        Routes.providerImageScreen,
                        arguments:
                            (ApiBaseHelper.imageUrl + provider['avatar']),
                      );
                    },
                    child: Container(
                      width: 58.0,
                      height: 58.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: provider['avatar'] == null
                              ? AssetImage('images/profile_user.png')
                              : NetworkImage(
                                  ApiBaseHelper.imageUrl + provider['avatar']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          provider['title'] +
                              ' ' +
                              provider['fullName'] +
                              Extensions.getSortProfessionTitle(
                                  provider['professionalTitle']),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                  "images/ic_experience.png",
                                ),
                                height: 14.0,
                                width: 11.0,
                              ),
                              SizedBox(width: 3.0),
                              Expanded(
                                child: Text(
                                  practicingSince + " yrs experience",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                "ic_rating_golden"
                                    .imageIcon(width: 12, height: 12),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  provider['averageRating']
                                          ?.toStringAsFixed(1) ??
                                      "0",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '\u2022 ' + provider['professionalTitle'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              provider['isOfficeEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_office'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              provider['isVideoChatEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_video'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              provider['isOnsiteEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_onsite'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                'ic_forward'.imageIcon(
                  width: 9,
                  height: 15,
                )
              ],
            ),
          ).onClick(onTap: () {
            Navigator.of(context).pushNamed(Routes.providerProfileScreen,
                arguments: provider["doctorId"]);
          }),
        ],
      ),
    );
  }
}
