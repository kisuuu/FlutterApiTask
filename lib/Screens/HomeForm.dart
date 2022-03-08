import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_app/DatabaseHandler/DbHelper.dart';
import 'package:sql_app/Model/UserModel.dart';
import 'package:sql_app/Screens/LoginForm.dart';
import 'package:sql_app/Screens/dashboard.dart';
import 'package:sql_app/comm/comHelper.dart';
import 'package:sql_app/comm/genTextFormField.dart';

class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  late DbHelper dbHelper;
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conDelUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
    });
  }

  update() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel user = UserModel(uid, uname, email, passwd);
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog(context, "Successfully Updated");

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error Update");
        }
      }).catchError((error) {
        // ignore: avoid_print
        print(error);
        alertDialog(context, "Error");
      });
    }
  }

  delete() async {
    String delUserID = _conDelUserId.text;

    await dbHelper.deleteUser(delUserID).then((value) {
      if (value == 1) {
        alertDialog(context, "Successfully Deleted");

        updateSP(UserModel('4', 'Kishan04', 'kishan@gmail.com', '123456789'),
                false)
            .whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name!);
      sp.setString("email", user.email!);
      sp.setString("password", user.password!);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        title: const Center(
          child: Text(
            'Home',
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Update
                    getTextFormField(
                        controller: _conUserId,
                        isEnable: false,
                        icon: Icons.person,
                        hintName: 'User ID'),
                    const SizedBox(height: 10.0),
                    getTextFormField(
                        controller: _conUserName,
                        icon: Icons.person_outline,
                        inputType: TextInputType.name,
                        hintName: 'User Name'),
                    const SizedBox(height: 10.0),
                    getTextFormField(
                        controller: _conEmail,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        hintName: 'Email'),
                    const SizedBox(height: 10.0),
                    getTextFormField(
                      controller: _conPassword,
                      icon: Icons.lock,
                      hintName: 'Password',
                      isObscureText: true,
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        bottom: 10.0,
                      ),
                      // color: Colors.purple.shade300,
                      width: double.infinity,
                      child: FlatButton(
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: update,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        color: Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),

                    //Delete

                    getTextFormField(
                        controller: _conDelUserId,
                        isEnable: false,
                        icon: Icons.person,
                        hintName: 'User ID'),
                    // SizedBox(height: 10.0),
                    // SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 10.0),
                      width: double.infinity,
                      child: FlatButton(
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: delete,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        color: Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      width: double.infinity,
                      child: FlatButton(
                        child: const Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Dashboard(),
                            ),
                          );
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        color: Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
