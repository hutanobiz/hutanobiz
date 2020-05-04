import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';

class ProviderWidget extends StatelessWidget {
  ProviderWidget({
    Key key,
    @required this.data,
    @required this.degree,
    this.bookAppointment,
    this.isOptionsShow = true,
  })  : assert(data != null),
        super(key: key);

  final data;
  final String degree;
  final Function bookAppointment;
  final bool isOptionsShow;

  @override
  Widget build(BuildContext context) {
    String fee = "---";
    String speciality = "---";

    if (data['specialties'] != null) {
      if (data['specialties'][0] != null) {
        if (data['specialties'][0] is String) {
          speciality = data['specialties'][0]?.toString() ?? "---";
        } else {
          speciality = data['specialties'][0]["title"]?.toString() ?? "---";
        }
      }
    }

    if (data["consultanceFee"] != null) {
      for (dynamic consultanceFee in data["consultanceFee"]) {
        fee = consultanceFee["fee"].toString() ?? "---";
      }
    } else if (data["userId"] != null) {
      if (data["userId"]["consultanceFee"] != null) {
        for (dynamic consultanceFee in data["userId"]["consultanceFee"]) {
          fee = consultanceFee["fee"].toString() ?? "---";
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 22.0),
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
            padding: EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 58.0,
                  height: 58.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: data["userId"]["avatar"] == null
                          ? AssetImage('images/profile_user.png')
                          : NetworkImage(ApiBaseHelper.imageUrl +
                              data["userId"]["avatar"]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
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
                          "${data["userId"]["fullName"]}, $degree",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: AppColors.goldenTainoi,
                                size: 12.0,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                data['averageRating']?.toString() ??
                                    "---" + " \u2022",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  data['supervising']['professionalTitle']
                                          ?.toString() ??
                                      "----",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                "images/ic_experience.png",
                              ),
                              height: 11.0,
                              width: 11.0,
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            Expanded(
                              child: Text(
                                speciality,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "\$$fee",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Consultation fee",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: isOptionsShow
                ? const EdgeInsets.only(left: 12.0, right: 12.0)
                : const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          "images/ic_location_grey.png",
                        ),
                        height: 14.0,
                        width: 11.0,
                      ),
                      SizedBox(width: 3.0),
                      Expanded(
                        child: Text(
                          data['businessLocation']['address']?.toString() ??
                              "---",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                        "images/ic_distance.png",
                      ),
                      height: 14.0,
                      width: 14.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "--- miles", //TODO: distance
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isOptionsShow
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: AppColors.persian_indigo,
                      splashColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(13.0),
                          bottomLeft: Radius.circular(13.0),
                        ),
                        side: BorderSide(
                            width: 0.5, color: AppColors.persian_indigo),
                      ),
                      child: Text(
                        "Request Appointment",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: bookAppointment,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
