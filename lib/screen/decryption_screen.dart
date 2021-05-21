import 'dart:convert';
import 'dart:io';

import 'package:analyse_app/data/analyse_data.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'decription_result.dart';

class DecryptionScreen extends StatefulWidget {
  @override
  _DecryptionScreenState createState() => _DecryptionScreenState();
}

class _DecryptionScreenState extends State<DecryptionScreen> {
  TextEditingController cypherKeyController = TextEditingController();
  final cypherKey = GlobalKey<FormState>();

  //loading data
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  BuildContext loadingContext;

  Color border_color = Colors.black;

  File _image;
  final picker = ImagePicker();

  checkImageNull() {
    bool status = false;
    if (_image == null) {
      border_color = Colors.red;
      status = false;
    } else {
      border_color = Colors.black;
      status = true;
    }
    setState(() {});
    return status;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Roboto',
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Form(
                    key: cypherKey,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                      controller: cypherKeyController,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      onChanged: (val) {
                        cypherKey.currentState.validate();
                      },
                      validator: (val) {
                        final alphanumeric =
                            RegExp(r'^[a-zA-Z0-9!@#$%^&*(),.?: ]+$');
                        if (val.isEmpty) {
                          return "Key cannot be empty";
                        } else if (!alphanumeric.hasMatch(val)) {
                          return "Key only support alphanumeric and symbols !@#\$%^&*(),.?:";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: _image == null
                      ? InkWell(
                          onTap: getImage,
                          child: DottedBorder(
                            color: border_color,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            dashPattern: [6],
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                // color: Color(0xFFC4C4C4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: MediaQuery.of(context).size.height *
                                        0.2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    'Insert Image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 24,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                _image,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white)),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                InkWell(
                  onTap: () async {
                    if (cypherKey.currentState.validate() ||
                        !checkImageNull()) {
                      loadingContext = context;
                      Analyse.showLoading(
                          context: loadingContext, key: _keyLoader);
                      print(checkImageNull());
                      print(_image.path);
                      var dio = Dio();
                      FormData formData = FormData.fromMap({
                        "key": cypherKeyController.text,
                        "file": await MultipartFile.fromFile(_image.path),
                      });
                      var apiResult;
                      try {
                        apiResult = await dio.post(
                          Analyse.apiUrl + 'decrypt',
                          data: formData,
                        );
                      } catch (log) {
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();
                        Fluttertoast.showToast(
                          msg:
                              log /*'Plaintext or Key contain unsupported character'*/,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                      if (apiResult.statusCode == 200) {
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DecryptionResult(
                                  plainText: apiResult.data['plain_text']);
                            },
                          ),
                        );
                      } else {
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        'DECRYPT',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
