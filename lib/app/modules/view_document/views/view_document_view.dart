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
  final GlobalKey<SfSignaturePadState> signaturePadGlobalKey = GlobalKey();

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
              (controller.signedDocument == null)
                  ? IconButton(
                      onPressed: () {
                        controller.showSignaturePad.value =
                            !controller.showSignaturePad.value;
                        controller.update();
                      },
                      icon: const Icon(Icons.gesture),
                    )
                  : IconButton(
                      onPressed: () {
                        controller.shareDocument(sourceDocument: doc);
                      },
                      icon: const Icon(Icons.share),
                    ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: (controller.signedDocument == null)
                    ? SfPdfViewer.asset(doc.file)
                    : SfPdfViewer.memory(controller.signedDocument!),
              ),
              (controller.showSignaturePad.value == true)
                  ? Column(
                      children: [
                        SfSignaturePad(
                          key: signaturePadGlobalKey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.signAndSaveDocuments(
                                    signaturePadGlobalKey:
                                        signaturePadGlobalKey,
                                    sourceDocument: doc);
                              },
                              child: const Text("Sign document"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                signaturePadGlobalKey.currentState!.clear();
                              },
                              child: const Text("Clear"),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
