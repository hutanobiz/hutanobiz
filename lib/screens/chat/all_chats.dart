import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/chat/models/recent_chat_model.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/appointment_type_chip_widget.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';

class ChatMain extends StatefulWidget {
  ChatMain({Key? key}) : super(key: key);

  @override
  _ChatMainState createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  bool _isLoading = false;
  final seachAppointmentController = TextEditingController();
  final _searchDiseaseFocusNode = FocusNode();
  bool isIndicatorLoading = false;
  List<SearchAppointment>? recentChatList = [];

  @override
  void initState() {
    super.initState();

    _getMyDiseaseList();
  }

  _getMyDiseaseList() async {
    setState(() {
      isIndicatorLoading = true;
    });
    await ApiManager().getRecentChats().then((result) {
      if (result is RecentChatData) {
        setLoading(false);
        setState(() {
          isIndicatorLoading = false;
        });
        if (result.response != null) {
          setState(() {
            recentChatList = result.response;
          });
        }
      }
    }).catchError((dynamic e) {
      setState(() {
        isIndicatorLoading = false;
      });
      if (e is ErrorModel) {
        setLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        padding: const EdgeInsets.only(top: 10),
        isAddBack: false,
        addHeader: true,
        isBackRequired: false,
        child: Column(
          children: <Widget>[
            serachAppointmentWidget(context),
            recentChatListWidget(context),
          ],
        ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  Widget serachAppointmentWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacing15),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: seachAppointmentController,
              focusNode: _searchDiseaseFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onTap: () {},
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                prefixIcon: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(spacing8),
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: colorBlack2,
                    ),
                  ),
                ),
                hintText: 'Find Provider By Name',
                isDense: true,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
              )),
          suggestionsCallback: (pattern) async {
            return pattern.length > 0 ? await _searchAppointments(pattern) : [];
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, dynamic suggestion) {
            return searchChatProviderWidget(suggestion, context);
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (dynamic suggestion) {
            seachAppointmentController.text = '';
            Navigator.pushNamed(context, Routes.chat, arguments: suggestion)
                .then((value) {
              _getMyDiseaseList();
            });
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  Future<List<SearchAppointment>> _searchAppointments(String pattern) async {
    var aa = await ApiManager().searchAppointments(pattern);
    return aa;
  }

  Widget recentChatListWidget(BuildContext context) => isIndicatorLoading
      ? Expanded(
          child: Center(
            child: CustomLoader(),
          ),
        )
      : recentChatList == null ||
              (recentChatList == null || recentChatList!.isEmpty) &&
                  !isIndicatorLoading
          ? Expanded(
              child: Center(
                child: Text(
                  'No Messages Yet. \nBook an appointment to start messaging. ',
                  style: TextStyle(
                      fontSize: 16,
                      color: colorBlack2,
                      fontWeight: fontWeightSemiBold),
                ),
              ),
            )
          : Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      spacing16, spacing8, spacing16, spacing8),
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: recentChatList!.length,
                      itemBuilder: (context, index) {
                        return recentChatProviderWidget(
                            recentChatList![index], context);
                      })),
            );

  Container recentChatProviderWidget(
      SearchAppointment chatAppointment, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 8, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onTap: chatAppointment.doctor![0].avatar != null
                            ? () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.of(context).pushNamed(
                                  Routes.providerImageScreen,
                                  arguments: (ApiBaseHelper.imageUrl +
                                      chatAppointment.doctor![0].avatar!),
                                );
                              }
                            : null,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (chatAppointment.doctor![0].avatar == null
                                  ? AssetImage(FileConstants.icImgPlaceHolder)
                                  : NetworkImage(ApiBaseHelper.imageUrl +
                                      chatAppointment.doctor![0]
                                          .avatar!)) as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(50.0)),
                            border: new Border.all(
                              color: Colors.grey[300]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //     top: 0,
                    //     right: spacing10,
                    //     child: isOnline
                    //         ? CircleAvatar(
                    //             backgroundColor: Color(0xff009900),
                    //             radius: spacing10)
                    //         : SizedBox())
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: spacing8,
                      right: spacing8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          chatAppointment.doctor![0].title! +
                              ' ' +
                              chatAppointment.doctor![0].fullName!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: colorBlack,
                              fontWeight: fontWeightSemiBold,
                              fontSize: fontSize14),
                        ),
                        SizedBox(height: spacing4),
                        AppointmentTypeChipWidget(
                            appointmentType: chatAppointment.type),
                        SizedBox(height: spacing4),
                        Row(
                          children: [
                            Image(
                              image:
                                  AssetImage("images/ic_appointment_time.png"),
                              height: 16.0,
                              width: 16.0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              DateFormat('MMM dd, hh:mm a')
                                  .format(DateTime.utc(
                                          DateTime.parse(chatAppointment.date!)
                                              .year,
                                          DateTime.parse(chatAppointment.date!)
                                              .month,
                                          DateTime.parse(chatAppointment.date!)
                                              .day,
                                          int.parse(chatAppointment.fromTime!
                                              .split(':')[0]),
                                          int.parse(chatAppointment.fromTime!
                                              .split(':')[1]))
                                      .toLocal())
                                  .toString(),
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 12.0),
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
                      "View chat",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.chat,
                              arguments: chatAppointment)
                          .then((value) {
                        _getMyDiseaseList();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container searchChatProviderWidget(
      SearchAppointment chatAppointment, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.grey[200],
                    onTap: chatAppointment.doctor![0].avatar != null
                        ? () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).pushNamed(
                              Routes.providerImageScreen,
                              arguments: (ApiBaseHelper.imageUrl +
                                  chatAppointment.doctor![0].avatar!),
                            );
                          }
                        : null,
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (chatAppointment.doctor![0].avatar == null
                                  ? AssetImage(FileConstants.icImgPlaceHolder)
                                  : NetworkImage(ApiBaseHelper.imageUrl +
                                      chatAppointment.doctor![0].avatar!))
                              as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //     top: 0,
                //     right: spacing10,
                //     child: isOnline
                //         ? CircleAvatar(
                //             backgroundColor: Color(0xff009900),
                //             radius: spacing10)
                //         : SizedBox())
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: spacing8,
                  right: spacing8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chatAppointment.doctor![0].title! +
                          ' ' +
                          chatAppointment.doctor![0].fullName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: colorBlack,
                          fontWeight: fontWeightSemiBold,
                          fontSize: fontSize14),
                    ),
                    SizedBox(height: spacing4),
                    AppointmentTypeChipWidget(
                        appointmentType: chatAppointment.type),
                    SizedBox(height: spacing4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
