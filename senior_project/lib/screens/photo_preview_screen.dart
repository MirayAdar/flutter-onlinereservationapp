import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreviewScreen extends StatefulWidget {
  PhotoPreviewScreen(this.photoUrl);
  String photoUrl;
  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 35,
              color: const Color(0xfff5f5f5),
            ),
            children: [
              TextSpan(
                text: 'F',
              ),
              TextSpan(
                text: 'E',
                style: TextStyle(
                  color: const Color(0xffa11f1f),
                ),
              ),
              TextSpan(
                text: 'ASTER',
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: Column(
        children: [
          Text("Photo Preview",style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold),),
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.photoUrl),
            ),
          ),
        ],
      ),
    );
  }
}
