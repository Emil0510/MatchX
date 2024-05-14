import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

import '../../../Constants.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool isLoading = true;
  late PDFDocument doc;

  void loadPdf() async {
    // Load from assets
    doc = await PDFDocument.fromAsset('assets/privacy_policy.pdf');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Gizlilik Siyasəti",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: isLoading
            ? const Center(
              child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
            )
            : PDFViewer(document: doc),
      ),
    );
  }
}
