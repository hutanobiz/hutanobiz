import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/medical_history/add_medication_bottomsheet.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';

class MedicineInformation extends StatefulWidget {
  MedicineInformation({Key? key, this.args}) : super(key: key);
  dynamic args;

  @override
  _MedicineInformationState createState() => _MedicineInformationState();
}

class _MedicineInformationState extends State<MedicineInformation>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<int> selectedFilters = [];
  List<String> tabs = ['All', 'New', 'Reviewed', 'Discontinued'];
  List<String> medChangeString = ['Added', 'Reviewed', 'Discontinued'];
  List<String> medChangeString1 = ['New', 'Reviewed', 'Discontinued'];
  TextEditingController medSearchController = TextEditingController();
  List<Data>? appointmentMedication = [];
  String? patientId, appointmentId;
  ScrollController scrollController = ScrollController();
  int current_page = 1, last_page = 1;
  TabController? _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    patientId = getString(PreferenceKey.id);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (current_page < last_page) {
          current_page++;
          getMedicationHistoryApi(current_page);
        }
      }
    });
    getMedicationHistoryApi(1);

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(_handleTabControllerTick);

    super.initState();
  }

  void _handleTabControllerTick() {
    if (_currentIndex != _tabController!.index) {
      _currentIndex = _tabController!.index;
      getMedicationHistoryApi(1);
    }
  }

  getMedicationHistoryApi(int? page) async {
    setLoading(true);
    var filterString = '';
    if (_currentIndex != 0) {
      filterString += '&filters[0]=${_currentIndex - 1}';
    }

    await ApiManager()
        .getMedicationDetails(
            patientId, page, medSearchController.text, filterString)
        .then((value) {
      if (page == 1) {
        current_page = value!.currentPage!;
        last_page = value.totalPages!;
        appointmentMedication = value.data;
      } else {
        current_page = value!.currentPage!;
        last_page = value.totalPages!;
        appointmentMedication!.addAll(value.data!);
      }
      setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        isLoading: isLoading,
        padding: EdgeInsets.only(bottom: spacing20),
        addBottomArrows: MediaQuery.of(context).viewInsets.bottom == 0,
        onForwardTap: () {
          if (widget.args['isEdit']) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).pushNamed(Routes.routeAddPharmacy,
                arguments: {'isEdit': false});
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("My Medications",
                          style: AppTextStyle.boldStyle(fontSize: 18)),
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(width: 1.0, color: AppColors.windsor),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (context) {
                              return AddMedicationBottomSheet(
                                user: patientId,
                                appointment: appointmentId,
                                status: '0',
                                id: '',
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              getMedicationHistoryApi(1);
                            }
                          });
                        },
                        child: Text('New Medication',
                            style: TextStyle(color: AppColors.windsor)))
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                height: 40,
                decoration: BoxDecoration(
                    color: colorBlack2.withOpacity(0.06),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: TextFormField(
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      getMedicationHistoryApi(1);
                    });
                  },
                  controller: medSearchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIconConstraints: BoxConstraints(),
                    prefixIcon: GestureDetector(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(spacing8),
                            child: Image.asset(FileConstants.icSearchBlack,
                                color: colorBlack2, width: 20, height: 20))),
                    isDense: true,
                    hintStyle: TextStyle(
                        color: colorBlack2,
                        fontSize: fontSize13,
                        fontWeight: fontWeightRegular),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppColors.goldenTainoi,
                    indicator: CircleTabIndicator(
                        color: AppColors.goldenTainoi, radius: 4),
                    controller: _tabController,
                    tabs: _tabsHeader(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 5,
                  )),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: patientReportedMedicationWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _tabsHeader() {
    return tabs
        .asMap()
        .map((index, text) => MapEntry(
            index,
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _tabController!.index == index
                        ? AppColors.goldenTainoi
                        : colorBlack2,
                    fontSize: fontSize14,
                    fontWeight: _tabController!.index == index
                        ? fontWeightMedium
                        : fontWeightRegular),
              ),
            )))
        .values
        .toList();
  }

  patientReportedMedicationWidget() {
    return ListView.separated(
        shrinkWrap: true,
        controller: scrollController,
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 10),
        itemCount: appointmentMedication!.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(width: 0.5, color: Colors.grey[100]!)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26.0),
                        child: Image.network(
                            ApiBaseHelper.image_base_url +
                                (appointmentMedication![index].doctor == null
                                    ? appointmentMedication![index]
                                        .user!
                                        .avatar!
                                    : appointmentMedication![index]
                                        .doctor!
                                        .avatar!),
                            width: 52,
                            height: 52),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${appointmentMedication![index].name} ${(appointmentMedication![index].status == 2 ? '' : appointmentMedication![index].dose)} is ${medChangeString[appointmentMedication![index].status!]} by ${appointmentMedication![index].doctor == null ? 'Me' : appointmentMedication![index].doctor!.fullName}',
                                style: AppTextStyle.mediumStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.goldenTainoi.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                medChangeString1[
                                    appointmentMedication![index].status!],
                                style: TextStyle(
                                    color: AppColors.goldenTainoi,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        appointmentMedication![index].providerReason == null
                            ? SizedBox()
                            : Text(
                                appointmentMedication![index].providerReason ??
                                    '',
                                style: AppTextStyle.regularStyle(fontSize: 14),
                              ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_calendar_grey.png',
                              height: 16,
                            ),
                            SizedBox(width: 8),
                            Text(DateFormat('MM/dd/yyyy').format(dateTime(
                                appointmentMedication![index].createdAt))),
                          ],
                        )
                      ],
                    )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  dateTime(response) {
    DateTime date = DateTime.utc(
            DateTime.parse(response).year,
            DateTime.parse(response).month,
            DateTime.parse(response).day,
            DateTime.parse(response).hour,
            DateTime.parse(response).minute)
        .toLocal();
    return date;
  }

  setLoading(loading) {
    setState(() {
      isLoading = loading;
    });
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    throw UnimplementedError();
  }

  // @override
  // BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
