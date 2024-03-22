import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

String predict="ds";

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _image;

  Future<void> _captureImage() async {
    final PickedFile? image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future upload() async{

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://102c-103-16-69-134.ngrok-free.app/upload"),
      );
      print("What the fuck is happening");

      var imageFile = File(_image!.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // This should match the field name expected by the server
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Change to 'image', 'jpg' or 'image', 'png' if needed
        ),
      );
        print("What the fuck is happening");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);
    print("Fuck happened!");
      predict=result.toString();
      if(predict=="null")
        predict="Neutral";
      print(predict);

    }
    catch(e)
    {
      print(e);
    }
    // _hasp=true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFFFD1D1),
        title: Text('Mood Checker',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.w100,
              fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: _captureImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE4A3BC),
              ),
              child: Text('Take a Picture'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE4A3BC),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context){
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                  await upload();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Predict()));

                },
                child: Text('Predict')
            ),
          ],
        ),
      ),
    );
  }
}


class Predict extends StatefulWidget {
  const Predict({Key? key}) : super(key: key);

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD1D1),
        automaticallyImplyLeading: false,
        elevation: 0,

        title: const Text('Mood Detected !',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.w100,
              fontSize: 25),
        ),
      ),
      body:
      Center(child: Text("Your Mood is "+predict,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color:Colors.black,
        ),
      ),
      ),
    );
  }
}