import 'package:digital_signature/app/data/sample/sample.dart';
import 'package:digital_signature/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: SampleDocument.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: const Icon(Icons.description),
            title: Text(SampleDocument[index].title),
            onTap: () => Get.toNamed(
              Routes.VIEW_DOCUMENT,
              arguments: SampleDocument[index],
            ),
          );
        },
      ),
    );
  }
}
