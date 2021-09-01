import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_provider_starter/models/user.dart';
import 'package:sqlite_provider_starter/services/user_service.dart';
import 'package:sqlite_provider_starter/widgets/app_textfield.dart';
import 'package:sqlite_provider_starter/widgets/dialogs.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.blue],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Register User',
                        style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      ),
                    ),
                    Focus(
                      onFocusChange: (value) async {
                        if (!value) {
                          String result = await context
                              .read<UserService>()
                              .chechIfUserExists(
                                  usernameController.text.trim());
                          if (result == 'ok') {
                            context.read<UserService>().userExists = true;
                          } else {
                            context.read()<UserService>().userExists = false;
                            if (!result.contains(
                                'This user already exists in the database. Please choose a new one.')) {
                              showSnackBar(context, result);
                            }
                          }
                        }
                      },
                      child: AppTextField(
                        controller: usernameController,
                        labelText: 'Please enter your username',
                      ),
                    ),
                    Selector<UserService, bool>(
                      selector: (context, value) => value.userExists,
                      builder: (context, value, child) {
                        return value
                            ? Text(
                                ///check if value is true then username shown else a empty container
                                'username exists, please choose another',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              )
                            : Container();
                      },
                    ),
                    AppTextField(
                      controller: nameController,
                      labelText: 'Please enter your name',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.purple),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (usernameController.text.isEmpty ||
                              nameController.text.isEmpty) {
                            showSnackBar(context, 'please enter all fileds !');
                          } else {
                            User user = User(
                                name: nameController.text.trim(),
                                username: usernameController.text.trim());

                            String result = await context
                                .read<UserService>()
                                .createUser(user);

                            if (result != 'ok') {
                              showSnackBar(context, result);
                            } else {
                              showSnackBar(
                                  context, 'New User Sucessfully created');
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Selector<UserService, bool>(
            selector: (context, value) => value.bussyCreate,
            builder: (context, value, child) {
              return value ? AppProgressIndicator() : Container();
            },
          ),
        ],
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            backgroundColor: Colors.purple,
          ),
        ),
      ),
    );
  }
}
