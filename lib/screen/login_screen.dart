import 'dart:io';

import 'package:chatting_app2/addImage/addImage.dart';
import 'package:chatting_app2/screen/chat_screen.dart';
import 'package:chatting_app2/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login_Screen extends StatefulWidget {
  Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  // Controll Variable
  bool isLogin = true;
  bool isSpinner = false;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // User Name, Email, Password, image
  String userName = '';
  String email = '';
  String password = '';
  File? imageFile;

  // Firebase Authentication, Firebase Database, Firebase Storage Instnace
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // validate Method
  void validateFunc() {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  // Dialogue를 띄우는 창
  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          child: AddImage(
            imageFile: imageFile,
            sendImageFile: sendImageFile,
          ),
        );
      },
    );
  }

  // login_screen.dart에 imageFile을 대입하는 Method
  void sendImageFile(File imageFile) {
    this.imageFile = imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isSpinner,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Upper Green Color Position
                  Positioned(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.green[200],
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(bottom: 60.0),
                        child: Text(
                          isLogin ? 'Welcome To Login' : 'Welcome To Register',
                          style: TEXT_COLOR,
                        ),
                      ),
                    ),
                  ),

                  // Login, Register, Form Position
                  AnimatedPositioned(
                    top: 125,
                    left: 20,
                    right: 20,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: AnimatedContainer(
                      height: isLogin ? 300.0 : 350.0,
                      duration: Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Login, Register
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          isLogin = true;
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Login',
                                            style: TextStyle(
                                                color: isLogin
                                                    ? Colors.black
                                                    : Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5.0),
                                          if (isLogin)
                                            Divider(
                                              height: 1.0,
                                              thickness: 3.0,
                                              color: Colors.blue,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Register',
                                            style: TextStyle(
                                                color: !isLogin
                                                    ? Colors.black
                                                    : Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5.0),
                                          if (!isLogin)
                                            Divider(
                                              height: 1.0,
                                              thickness: 3.0,
                                              color: Colors.blue,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Login Form (Email, PassWord)
                            if (isLogin)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          key: ValueKey(1),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                !(value.contains('@'))) {
                                              return 'Email 조건에 맞지 않습니다.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            email = value!;
                                          },
                                          onChanged: (value) {
                                            email = value;
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email),
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextFormField(
                                          key: ValueKey(2),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 6) {
                                              return '비밀번호 최소 6자리 여야 합니다.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            password = value!;
                                          },
                                          onChanged: (value) {
                                            password = value;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.password),
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Register Form(User Name, Email, Password)
                            if (!isLogin)
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          key: ValueKey(3),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 2) {
                                              return '이름 입력 조건이 맞지 않습니다.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            userName = value!;
                                          },
                                          onChanged: (value) {
                                            userName = value;
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.account_circle),
                                            hintText: 'User Name',
                                            hintStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(5.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextFormField(
                                          key: ValueKey(4),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                !(value.contains('@'))) {
                                              return '이메일 형식이 맞지 않습니다.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            email = value!;
                                          },
                                          onChanged: (value) {
                                            email = value;
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email),
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(5.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        TextFormField(
                                          key: ValueKey(5),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 6) {
                                              return '비밀번호 최소 6자리 여야 합니다.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            password = value!;
                                          },
                                          onChanged: (value) {
                                            password = value;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.password),
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(5.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Button
                  AnimatedPositioned(
                    top: isLogin ? 380 : 430,
                    left: 150,
                    right: 150,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.red],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                isSpinner = true;
                              });

                              // 로고인 할 떄
                              if (isLogin) {
                                validateFunc();

                                try {
                                  UserCredential user = await _authentication
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  if (user != null) {
                                    setState(() {
                                      isSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${e}'),
                                    ),
                                  );

                                  setState(() {
                                    isSpinner = false;
                                  });
                                }
                              }

                              // Register 할 떄
                              if (!isLogin) {
                                validateFunc();

                                // image를 등록하지 않았으면 Register를 할 수 없게 한다.
                                if (imageFile == null) {
                                  setState(() {
                                    isSpinner = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('이미지를 등록해주세요.'),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  // FireBase Authentication에 등록
                                  UserCredential newUser = await _authentication
                                      .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  // Image를 FireBase Storage에 등록
                                  print('Image를 FireBase Storage에 등록했습니다.');
                                  Reference ref = _storage
                                      .ref()
                                      .child('user_image')
                                      .child(newUser.user!.uid + '.png');
                                  await ref.putFile(imageFile!);

                                  // FireBase DataBase에 User 정보 등록
                                  String image_url = await ref.getDownloadURL();
                                  print('Firebase DataBase에 User 정보를 등록했습니다.');
                                  await _firestore
                                      .collection('user')
                                      .doc(newUser.user!.uid)
                                      .set(
                                    {
                                      'userName': userName,
                                      'email': email,
                                      'image_url': image_url,
                                    },
                                  );

                                  if (newUser != null) {
                                    setState(() {
                                      isSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${e}'),
                                    ),
                                  );

                                  setState(() {
                                    isSpinner = false;
                                  });
                                }
                              }
                            },
                            icon: Icon(Icons.arrow_forward),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Lower Text, Google Icon Button
                  AnimatedPositioned(
                    top: isLogin ? 500 : 550,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(isLogin ? 'on Login With' : 'on Register With'),
                          SizedBox(
                            height: 10.0,
                          ),
                          if (!isLogin)
                            TextButton.icon(
                              onPressed: () {
                                showAlert();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red[200],
                                primary: Colors.white,
                                minimumSize: Size(155, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              icon: Icon(Icons.add),
                              label: Text('Add Image'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
