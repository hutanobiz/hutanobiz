import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/permission_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class MyContacts extends StatefulWidget {
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else {
      PermissionUtils.requestPermission([Permission.contacts], context,
          permissionGrant: () {
        getAllContacts();
        searchController.addListener(() {
          filterContacts();
        });
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Search',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: new BorderSide(color: const Color(0xff372786))),
                prefixIconConstraints:
                    BoxConstraints(maxWidth: 50, maxHeight: 50),
                suffix: GestureDetector(
                  onTap: () {
                    searchController.clear();
                  },
                  child: Text(
                    "CLEAR",
                    style: const TextStyle(
                      color: colorPurple100,
                    ),
                  ),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    FileConstants.icSearchBlack,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ),
          ),
          listItemsExist == true
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearching == true
                        ? contactsFiltered.length
                        : contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = isSearching == true
                          ? contactsFiltered[index]
                          : contacts[index];

                      return ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(
                                color: colorBlack2,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                          ),
                          subtitle: Text(
                            contact.phones.length > 0
                                ? contact.phones.elementAt(0).value
                                : '',
                            style: const TextStyle(
                                color: colorBlack2,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                          ),
                          trailing: Text("Invited"),
                          leading: (contact.avatar != null &&
                                  contact.avatar.length > 0)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.yellow[800],
                                            Colors.yellow[400],
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight)),
                                  child: CircleAvatar(
                                      child: Text(contact.initials(),
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.transparent)));
                    },
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      isSearching
                          ? 'No search results to show'
                          : 'No contacts exist',
                      style: Theme.of(context).textTheme.headline6),
                ),
        ],
      ),
    );
  }
}
