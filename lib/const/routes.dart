import 'package:api_mock_call/const/app_string.dart';
import 'package:api_mock_call/controller/contact_binding.dart';
import 'package:api_mock_call/view/add_contact_view.dart';
import 'package:api_mock_call/view/home_view.dart';
import 'package:get/get.dart';

class Routes {
  static final intialRoute = '/';
  static final addContactView = '/addContactView';

  static final routes = [
    GetPage(
      name: intialRoute,
      page: () => MyHomePage(title: AppString.contactInfoTitleText),
      binding: ContactBinding(),
    ),
    GetPage(
      name: addContactView,
      page: () => AddContactView(),
      binding: ContactBinding(),
    ),
  ];
}
