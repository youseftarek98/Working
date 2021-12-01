import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/screens/auth/login.dart';
import 'package:work_in/services/global_method.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;
  late TextEditingController _fullNameTextEditingController =
      TextEditingController(text: '');
  late TextEditingController _positionCPTextEditingController =
      TextEditingController(text: '');
  late TextEditingController _emailTextEditingController =
      TextEditingController(text: '');

  late TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  late TextEditingController _phoneTextEditingController =
      TextEditingController(text: '');

  FocusNode _fullNameFocusNode = FocusNode();

  FocusNode _emailFocusNode = FocusNode();

  FocusNode _passwordFocusNode = FocusNode();

  FocusNode _positionFocusNode = FocusNode();

  FocusNode _phoneFocusNode = FocusNode();

  File? imageFile;

  bool _obscureText = true;

  final _signUpGlobalKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String ? url ;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _phoneTextEditingController.dispose();
    _positionCPTextEditingController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _positionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormSignUp() async {
    final isValid = _signUpGlobalKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            context: context, error: 'Please pick up a image');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.toLowerCase().trim(),
            password: _passwordTextEditingController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        url = await ref.getDownloadURL() ;
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameTextEditingController.text,
          'email': _emailTextEditingController.text,
          'userImageUrl': url,
          'phoneNumber': _phoneTextEditingController.text,
          'positionInCompany': _positionCPTextEditingController.text,
          'createsAt': Timestamp.now()
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        //  print('form not valid ========================');
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(context: context, error: error.toString());
        print('error occurred $error');
      }

      //print('form not valid ========================');
    } else {
      print('form not valid ');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.red,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
            'https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=' ,
            ///  'https://images.unsplash.com/photo-1550439062-609e1531270e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
            placeholder: (context, url) => Image.asset(
              'asset/images/WhatsApp Image 2021-11-20 at 6.51.27 AM.jpeg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Already have an account ?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const TextSpan(text: '   '),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                      text: 'Login',
                      style: TextStyle(
                          color: Colors.blue.shade300,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                ])),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Form(
                    key: _signUpGlobalKey,
                    child: Column(
                      children: [
                        ///Full name
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: _fullNameFocusNode,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field can\'t be missing';
                                  }
                                  return null;
                                },
                                controller: _fullNameTextEditingController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Full name',
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.pink.shade700)),
                                    errorBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red))),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: size.width * 0.24,
                                      height: size.width * 0.24,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: imageFile == null
                                            ? Image.network(
                                                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                imageFile!,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 0.0,
                                      right: 0.0,
                                      child: InkWell(
                                        onTap: () => _showImageDialog(),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.pink,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                imageFile == null
                                                    ? Icons.add_a_photo
                                                    : Icons.edit_outlined,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        ///Email
                        TextFormField(
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid address';
                            }
                            return null;
                          },
                          controller: _emailTextEditingController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        ///Password
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneFocusNode),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          obscureText: _obscureText,
                          controller: _passwordTextEditingController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        /// phone number
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          focusNode: _phoneFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field can\'t be missing';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            print(
                                '_phoneTextEditingController.text : ${_phoneTextEditingController.text}');
                          },
                          controller: _phoneTextEditingController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        /// Position
                        GestureDetector(
                          onTap: () => _showJobsDialog(size),
                          child: TextFormField(
                            enabled: false,
                            focusNode: _positionFocusNode,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _submitFormSignUp,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field can\'t be missing';
                              }
                              return null;
                            },
                            controller: _positionCPTextEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'Position in the company',
                                hintStyle: const TextStyle(color: Colors.white),
                                disabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.pink.shade700)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 40,
                ),
                _isLoading
                    ? Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : MaterialButton(
                        onPressed: _submitFormSignUp,
                        color: Colors.pink.shade700,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide.none),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.person_add,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _pickImageWithCamera() async {
    try {
      PickedFile? pickedFile = await ImagePicker()
          .getImage(
          source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);
      _cropperImage(pickedFile!.path);
    }catch(error){
      GlobalMethod.showErrorDialog(context: context, error: '$error') ;
    }
    Navigator.pop(context);
  }

  void _pickImageWithGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
    //setState(() {
    //  imageFile = File(pickedFile!.path);
    //});
    _cropperImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropperImage(filePath) async {
    File? cropImage = await ImageCropper.cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (cropImage != null) {
      setState(() {
        imageFile = cropImage;
      });
    }
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: _pickImageWithCamera,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera,
                            color: Colors.purple,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.purple,
                            ),
                          )
                        ],
                      ),
                    )),
                InkWell(
                  onTap: _pickImageWithGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showJobsDialog(size) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Jobs ',
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jobsList.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _positionCPTextEditingController.text =
                              Constants.jobsList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red[200],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.jobsList[index],
                              style: const TextStyle(
                                  color: Color(0xFF00325A),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Cancel filter'),
              )
            ],
          );
        });
  }
}
