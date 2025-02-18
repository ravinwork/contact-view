import 'package:api_mock_call/const/app_string.dart';
import 'package:api_mock_call/const/color_assest.dart';
import 'package:api_mock_call/const/routes.dart';
import 'package:api_mock_call/controller/contact_controller.dart';
import 'package:api_mock_call/model/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class MyHomePage extends GetView<ContactController> {
  MyHomePage({super.key, required this.title});

  final String title;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.addContactView),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.contactModel?.value?.contacts?.isNotEmpty ?? false
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              controller.searchString.value = value;
                              controller.searchContact(query: value);
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorAssest.blackColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorAssest.blackColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorAssest.redColor),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorAssest.redColor),
                                ),
                                hintText: AppString.searchText,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    controller.searchString.value = '';
                                  },
                                  icon: Icon(Icons.cancel_outlined),
                                )),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.searchString.isEmpty
                              ? controller.contactModel?.value?.contacts?.length
                              : controller.searchModel?.value?.contacts?.length,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          itemBuilder: (context, index) {
                            final contact = controller.searchString.isEmpty
                                ? (controller
                                    .contactModel?.value?.contacts?[index])
                                : (controller
                                    .searchModel?.value?.contacts?[index]);
                            final color = Color(
                                    (math.Random().nextDouble() * 0xFFFFFF)
                                        .toInt())
                                .withValues(alpha: 0.25);
                            return contactInfoWidget(contact, color, index);
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox();
      }),
    );
  }

  Widget contactInfoWidget(Contact? contact, Color color, int index) {
    return GestureDetector(
      onTap: () {
        controller.updateContactInteraction(contact);
        searchController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text(contact?.name?[0] ?? ''),
              ),
              SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact?.name ?? ''),
                  SizedBox(height: 2),
                  Text(contact?.phone ?? ''),
                  SizedBox(height: 2),
                  Text(contact?.email ?? ''),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () => controller.removeContact(index: index),
                icon: Icon(
                  CupertinoIcons.delete,
                  color: ColorAssest.redColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
