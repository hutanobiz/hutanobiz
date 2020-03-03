import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState> _searchKey = GlobalKey<FormFieldState>();

  ApiBaseHelper api = new ApiBaseHelper();

  Future<List<dynamic>> _titleFuture;

  EdgeInsetsGeometry _edgeInsetsGeometry =
      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0);

  @override
  void initState() {
    _titleFuture = api.getProfessionalTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white_smoke,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: _edgeInsetsGeometry,
              child: adressBar(),
            ),
            Padding(
              padding: _edgeInsetsGeometry,
              child: searchBar(),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(22.0),
                    topRight: const Radius.circular(22.0),
                  ),
                ),
                child: professionalTitle(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomnavigationBar(),
    );
  }

  Widget adressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 15.0,
          height: 18.0,
          image: AssetImage("images/ic_location.png"),
        ),
        SizedBox(width: 5.0),
        Text(
          "138,Las Vegas..",
          style: TextStyle(
            color: AppColors.midnight_express,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 15.0),
        Image(
          width: 8.0,
          height: 4.0,
          image: AssetImage("images/ic_arrow_down.png"),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Image(
              width: 20.0,
              height: 20.0,
              image: AssetImage("images/ic_notification.png"),
            ),
          ),
        )
      ],
    );
  }

  Widget searchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "What are you looking for?",
          style: TextStyle(
            color: AppColors.midnight_express,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.0),
        TextFormField(
          key: _searchKey,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hasFloatingPlaceholder: false,
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
            labelText: "Search for doctors or by specialty...",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image(
                width: 34.0,
                height: 34.0,
                image: AssetImage("images/ic_search.png"),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
          ),
        ),
      ],
    );
  }

  Widget professionalTitle() {
    return FutureBuilder<List<dynamic>>(
      future: _titleFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data;
          return GridView.builder(
            padding: const EdgeInsets.all(20.0),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18.0,
              crossAxisSpacing: 21.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: "images/dummy_title_image.png",
                      image: '',
                      //TODO: add title image
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      data[index]["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.chooseSpecialities,
                      arguments: data[index]["_id"]);
                },
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
    );
  }

  Widget bottomnavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        border: Border.all(width: 0.5, color: Colors.grey[300]),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.persian_indigo,
          unselectedItemColor: Colors.grey[400],
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ic_home.png")),
              activeIcon: ImageIcon(AssetImage("images/ic_active_home.png")),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ic_appointments.png")),
              activeIcon:
                  ImageIcon(AssetImage("images/ic_active_appointments.png")),
              title: Text('Appointments'),
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("images/ic_settings.png")),
                activeIcon:
                    ImageIcon(AssetImage("images/ic_active_settings.png")),
                title: Text('Settings'))
          ],
        ),
      ),
    );
  }
}
