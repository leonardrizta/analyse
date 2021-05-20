import 'package:flutter/material.dart';

import 'decryption_screen.dart';
import 'encryption_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "WHAT DO YOU WANT TO DO?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EncryptionScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 64,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Text(
                      'ENCRYPT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          1.0,
                          1.0,
                        ), // shadow direction: bottom right
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "OR",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DecryptionScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 64,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Text(
                      'DECRYPT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          1.0,
                          1.0,
                        ), // shadow direction: bottom right
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
