import 'dart:convert';
import 'package:api_mock_call/const/routes.dart';
import 'package:api_mock_call/model/contact_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  var isLoading = false.obs;
  Rx<ContactModel?>? contactModel = ContactModel().obs;
  Rx<ContactModel?>? searchModel = ContactModel(contacts: []).obs;
  RxString searchString = ''.obs;
  RxInt lastContactID = 30.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchData();
  }

  fetchData() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      final String response =
          await rootBundle.loadString('assets/contact_data.json');
      final data = await json.decode(response);
      contactModel?.value = ContactModel.fromJson(data);
      isLoading.value = false;
    } catch (e) {
      print('Error while getting data is $e');
      isLoading.value = false;
    }
    refresh();
  }

  addContactInfo({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (contactModel?.value?.contacts?.isNotEmpty ?? false) {
      final lastContactId = contactModel?.value?.contacts?.last.id ?? 0;
      final nextContactId = lastContactId + 1;
      contactModel?.value?.contacts?.add(
          Contact(email: email, id: nextContactId, name: name, phone: phone));
    } else {
      contactModel?.value?.contacts
          ?.add(Contact(email: email, id: 1, name: name, phone: phone));
    }
  }

  removeContact({required int index}) {
    if (contactModel?.value?.contacts?.isNotEmpty ?? false) {
      contactModel?.value?.contacts?.removeAt(index);
      contactModel?.refresh();
    }
  }

  updateContact({
    required bool isUpdate,
    required int id,
    required String name,
    required String phone,
    required String email,
  }) {
    if (isUpdate) {
      final contactDetails = Contact(
        id: id,
        email: email,
        name: name,
        phone: phone,
      );
      final index =
          contactModel?.value?.contacts?.indexWhere((test) => test.id == id);
      contactModel?.value?.contacts?.removeAt(index ?? 0);
      contactModel?.value?.contacts?.insert(index ?? 0, contactDetails);
      contactModel?.refresh();
    } else {
      final newID = lastContactID.value + 1;
      final contactDetails = Contact(
        id: newID,
        email: email,
        name: name,
        phone: phone,
        interactionCount: 1,
        lastInteracted: DateTime.now(),
      );
      contactModel?.value?.contacts?.add(contactDetails);
      contactModel?.refresh();
    }
    Get.back();
  }

  searchContact({required String query}) {
    searchModel?.value?.contacts?.clear();
    contactModel?.value?.contacts?.forEach((element) {
      if (query.isNumericOnly && (element.phone?.contains(query) ?? false)) {
        searchModel?.value?.contacts?.add(element);
      } else if ((element.email?.contains(query) ?? false)) {
        searchModel?.value?.contacts?.add(element);
      } else if ((element.name?.contains(query) ?? false)) {
        searchModel?.value?.contacts?.add(element);
      }
    });
    searchModel?.refresh();
  }

  void updateContactInteraction(Contact? contact) async {
    final index = contactModel?.value?.contacts
            ?.indexWhere((test) => test.id == contact?.id) ??
        0;
    contactModel?.value?.contacts?[index].interactionCount =
        (contactModel?.value?.contacts?[index].interactionCount ?? 0) + 1;
    contactModel?.value?.contacts?[index].lastInteracted = DateTime.now();
    sortContacts(contact);
  }

  void sortContacts(Contact? contact) {
    contactModel?.value?.contacts?.sort((a, b) {
      // Score calculation: more recent interactions are weighted higher
      int scoreA = a.interactionCount! * 2 +
          (DateTime.now().difference(a.lastInteracted!).inDays * -1);
      int scoreB = b.interactionCount! * 2 +
          (DateTime.now().difference(b.lastInteracted!).inDays * -1);

      return scoreB.compareTo(scoreA); // Sort descending
    });
    contactModel?.refresh();
    Get.toNamed(Routes.addContactView, arguments: contact);
    searchString.value = '';
  }
}
