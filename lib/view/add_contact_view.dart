import 'package:api_mock_call/const/app_string.dart';
import 'package:api_mock_call/const/app_validation.dart';
import 'package:api_mock_call/const/color_assest.dart';
import 'package:api_mock_call/controller/contact_controller.dart';
import 'package:api_mock_call/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactView extends GetView<ContactController> {
  AddContactView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final isUpdate = Get.arguments != null;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      final Contact? contact = Get.arguments;
      nameController.text = contact?.name ?? '';
      phoneController.text = contact?.phone ?? '';
      emailController.text = contact?.email ?? '';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          isUpdate
              ? AppString.updateContactTitleText
              : AppString.addContactTitleText,
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              commonTextField(
                controller: nameController,
                title: AppString.enterNameText,
                validator: (input) => (input ?? '').isValidString()
                    ? null
                    : AppString.valiePhoneText,
              ),
              SizedBox(height: 20),
              commonTextField(
                controller: phoneController,
                title: AppString.enterPhoneText,
                validator: (input) => (input ?? '').isValidPhone()
                    ? null
                    : AppString.valiePhoneText,
              ),
              SizedBox(height: 20),
              commonTextField(
                controller: emailController,
                title: AppString.enterEmailText,
                validator: (input) => (input ?? '').isValidEmail()
                    ? null
                    : AppString.validEmailText,
              ),
              SizedBox(height: 20),
              Text(AppString.notePhoneNumberText),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.updateContact(
                      isUpdate: isUpdate,
                      id: isUpdate ? ((Get.arguments as Contact).id ?? 0) : 0,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                    );
                  }
                },
                child: Text(
                  isUpdate
                      ? AppString.updateButtonText
                      : AppString.submitButtonText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonTextField({
    required TextEditingController controller,
    required String title,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorAssest.blackColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorAssest.blackColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorAssest.redColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorAssest.redColor),
          ),
          hintText: title),
    );
  }
}
