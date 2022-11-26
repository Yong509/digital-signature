import 'dart:io';

import 'package:digital_signature/app/data/models/document_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class ViewDocumentController extends GetxController {
  final showSignaturePad = false.obs;

  List<int>? signedDocumentByte;
  Uint8List? signedDocument;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  signAndSaveDocuments(
      {required GlobalKey<SfSignaturePadState> signaturePadGlobalKey,
      required DocumentModel sourceDocument}) async {
    ByteData certBytes =
        await rootBundle.load('assets/certificate/certificate.pfx');
    final Uint8List certificateBytes = certBytes.buffer.asUint8List();

    final ByteData docBytes = await rootBundle.load(sourceDocument.file);
    final Uint8List documentBytes = docBytes.buffer.asUint8List();

    PdfDocument document = PdfDocument(inputBytes: documentBytes);

    int pageCount = document.pages.count;
    PdfPage page = document.pages[pageCount - 1];

    final image =
        await signaturePadGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    PdfSignatureField signatureField = PdfSignatureField(
      page,
      'signature',
      bounds: const Rect.fromLTRB(300, 500, 550, 700),
      signature: PdfSignature(
        certificate: PdfCertificate(certificateBytes, 'password'),
        contactInfo: 'yong@fmail.com',
        reason: 'Approved document',
        digestAlgorithm: DigestAlgorithm.sha256,
        cryptographicStandard: CryptographicStandard.cms,
      ),
    );

    PdfGraphics? graphics = signatureField.appearance.normal.graphics;

    graphics?.drawImage(PdfBitmap(bytes!.buffer.asUint8List()),
        const Rect.fromLTWH(0, 0, 250, 200));

    document.form.fields.add(signatureField);
    document.form.flattenAllFields();

    signedDocumentByte = await document.save();

    final directory = await getApplicationSupportDirectory();
    final path = directory.path;
    File file = File('$path/${sourceDocument.id}_output.pdf');
    await file.writeAsBytes(signedDocumentByte!, flush: true);

    signedDocument = Uint8List.fromList(signedDocumentByte!);
    document.dispose();

    showSignaturePad.value = false;
    update();
  }

  shareDocument({required DocumentModel sourceDocument}) async {
    final directory = await getApplicationSupportDirectory();
    final path = directory.path;

    Share.shareXFiles([XFile('$path/${sourceDocument.id}_output.pdf')]);
  }
}
