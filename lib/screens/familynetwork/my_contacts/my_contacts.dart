import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/req_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_relation_list.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/permission_utils.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/list_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';

class MyContacts extends StatefulWidget {
  final TextEditingController controller;
  final List<Relations> relationList;
  final ValueSetter<Relations> onRelationSelected;

  const MyContacts(
      {Key key, this.controller, this.relationList, this.onRelationSelected})
      : super(key: key);
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  List<FamilyMembers> _finalMemberList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getPermissions(context);
    });
  }

  getPermissions(BuildContext context) async {
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

  _openStatePicker(String name, String phone, int index, bool isSearch) {
    showDropDownSheet(
        list: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Select Relation", style: TextStyle(fontSize: 24)),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.relationList.length,
              itemBuilder: (context, pos) {
                return InkWell(
                    onTap: () {
                      searchController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.onRelationSelected(widget.relationList[pos]);
                      var reqModel = FamilyMembers(
                          name: name,
                          phone: phone,
                          relationId:
                              widget.relationList[pos].relationId.toString(),
                          relation: widget.relationList[pos].relation);
                      _finalMemberList.add(reqModel);
                      Navigator.pop(context);
                      Provider.of<FamilyProvider>(context, listen: false)
                          .updateReqProviderMember(_finalMemberList);
                      debugPrint("SEARCHING $isSearch");
                      Provider.of<FamilyProvider>(context, listen: false)
                          .removeProviderContacts(index);
                      Provider.of<FamilyProvider>(context, listen: false)
                          .removeFilteredProviderContacts(index);
                    },
                    child: ListTile(
                      title: Center(
                        child: Text(widget.relationList[pos].relation),
                      ),
                    ));
              },
            ),
          ],
        ),
        context: context);
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      isLoading = false;
    });
    Provider.of<FamilyProvider>(context, listen: false)
        .updateProviderContacts(_contacts);
    // setState(() {
    //   contacts = _contacts;
    // });
  }

  filterContacts() {
    List<Contact> _contacts = [];

    _contacts.addAll(
        Provider.of<FamilyProvider>(context, listen: false).providerContacts);
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
    Provider.of<FamilyProvider>(context, listen: false)
        .updateFilteredProviderContacts(_contacts);
    // setState(() {
    //   contactsFiltered = _contacts;
    // });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (Provider.of<FamilyProvider>(context, listen: false)
                .filteredProviderContacts
                .length >
            0 ||
        contacts.length > 0);
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
          isLoading
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: CustomLoader(),
                ))
              : Consumer<FamilyProvider>(
                  builder: (context, familyProvider, __) {
                    return (familyProvider.providerContacts.length > 0 ||
                                familyProvider.filteredProviderContacts.length >
                                    0) ==
                            true
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: isSearching == true
                                  ? familyProvider
                                      .filteredProviderContacts.length
                                  : familyProvider.providerContacts.length,
                              itemBuilder: (context, index) {
                                Contact contact = isSearching == true
                                    ? familyProvider
                                        .filteredProviderContacts[index]
                                    : familyProvider.providerContacts[index];
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
                                    trailing: InkWell(
                                        onTap: () async {
                                          _openStatePicker(
                                              contact.displayName,
                                              contact.phones.elementAt(0).value,
                                              index,
                                              isSearching);
                                          // var reqModel = FamilyMembers(name: contact.displayName,phone: contact.phones.elementAt(0).value,relationId: "1");
                                          // _finalMemberList.add(reqModel);
                                          // Provider.of<FamilyProvider>(context,listen: false).updateReqProviderMember(ReqAddMember(familyMembers: _finalMemberList));
                                        },
                                        child: Text(
                                          "INVITE",
                                          style: TextStyle(
                                              color: colorPurple100,
                                              fontSize: 14,
                                              fontWeight: fontWeightMedium),
                                        )),
                                    leading: (contact.avatar != null &&
                                            contact.avatar.length > 0)
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(contact.avatar),
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
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                backgroundColor:
                                                    Colors.transparent)));
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
                          );
                  },
                ),
        ],
      ),
    );
  }
}
