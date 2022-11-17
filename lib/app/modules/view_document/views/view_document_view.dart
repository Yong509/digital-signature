import 'dart:developer';
import 'package:digital_signature/app/data/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nil/nil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../controllers/view_document_controller.dart';

class ViewDocumentView extends GetView<ViewDocumentController> {
  ViewDocumentView({Key? key}) : super(key: key);

  final DocumentModel doc = Get.arguments;

  @override
  Widget build(BuildContext context) {
    log(doc.file);
    return GetBuilder<ViewDocumentController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ViewDocumentView'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSignaturePad.value =
                      !controller.showSignaturePad.value;
                  controller.update();
                },
                icon: const Icon(Icons.gesture),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SfPdfViewer.asset(doc.file),
              ),
              (controller.showSignaturePad.value == true)
                  ? SfSignaturePad()
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
