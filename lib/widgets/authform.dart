import 'package:chat_app/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitfn, this.isLoading);
  final bool isLoading;

  final void Function(String email, String pass, String username, File img,
      bool isLogin, BuildContext ctx) submitfn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPass = '';
  File _userimg;

  void _pickedimg(File img) {
    _userimg = img;
  }

  void _trySubmit() {
    final isvalid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userimg == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Try adding an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isvalid) {
      _formkey.currentState.save();

      widget.submitfn(_userEmail.trim(), _userPass.trim(), _userName.trim(),
          _userimg, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(_pickedimg),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return 'Plz enter a valid email.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (val) {
                        _userEmail = val;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (val) {
                          if (val.isEmpty || val.length < 4) {
                            return 'Enter valid username having atleast 4 char.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (val) {
                          _userName = val;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return 'Pass must contain atleast 7 char. ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      onSaved: (val) {
                        _userPass = val;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup!'),
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create New Account'
                              : 'I already have an account'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
