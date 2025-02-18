import 'package:api_mock_call/controller/contact_controller.dart';
import 'package:get/get.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ContactController>(ContactController());
  }
}
