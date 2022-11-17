import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/view_document_controller.dart';

class ViewDocumentView extends GetView<ViewDocumentController> {
  const ViewDocumentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViewDocumentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ViewDocumentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
