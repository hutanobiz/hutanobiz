import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/req_add_member.dart';

class FamilyProvider extends ChangeNotifier {

  List<FamilyMembers> providerMembers = [];
  List<Contact> providerContacts = [];
  List<Contact> filteredProviderContacts = [];

  void updateReqProviderMember(List<FamilyMembers> members){
    providerMembers =  members;
    notifyListeners();
  }

  void removeRedProviderMember(int index){
    providerMembers.removeAt(index);
    notifyListeners();
  }

  void updateProviderContacts(List<Contact> members){
    providerContacts =  members;
    notifyListeners();
  }
  void addProviderContacts(Contact members){
    providerContacts.add(members);
    notifyListeners();
  }


  void removeProviderContacts(int index){
    providerContacts.removeAt(index);
    notifyListeners();
  }

  void updateFilteredProviderContacts(List<Contact> members){
    filteredProviderContacts =  members;
    notifyListeners();
  }
  void addFilteredProviderContacts(Contact members){
    filteredProviderContacts.add(members);
    notifyListeners();
  }

  void removeFilteredProviderContacts(int index){
    filteredProviderContacts.removeAt(index);
    notifyListeners();
  }

  void resetProvider(){
     providerMembers = [];
     providerContacts = [];
     filteredProviderContacts = [];
     notifyListeners();
  }
}