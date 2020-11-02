import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'package:get/get.dart';

class Admin extends StatefulWidget {
  static const String route = '/admin';
  @override
  _AdminPageState createState() => _AdminPageState();
}

List<DataRow> userList = [];

class _AdminPageState extends State<Admin> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  int role_selected = -1.obs;
  Widget build(BuildContext context) {
    final tabs = ['User Logins', 'Logs'];

    return DefaultTabController(
        length: 1,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'User Logins',
                  ),
                  //  Tab(
                  //    icon: Icon(Icons.directions_transit),
                  //    text: 'Admin Page 2',
                  //  ),
                  //  Tab(
                  //    icon: Icon(Icons.directions_bike),
                  //    text: 'Admin Page 3',
                  //  ),
                ],
              ),
              title: Text('Admin Menu'),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      _buildUsers(context),
                    ])),
                //PAGE 1 ADMIN SETTINGS
                // Icon(Icons.directions_transit),
                //PAGE 2 ADMIN SETTINGS
                // Icon(Icons.directions_bike),
                //PAGE 3 ADMIN SETTINGS
              ],
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Color.fromARGB(255, 255, 255, 255),
              backgroundColor: Color.fromARGB(255, 103, 58, 183),
              onPressed: () async {
                //POPUP SHOWS UP HERE
                bool result =
                    await showDialog(context: context, child: NewLoginPopup());
              },
              child: const Icon(Icons.person_add),
              tooltip: 'Create New Login',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Row(children: [
                    IconButton(
                      tooltip: 'Search',
                      icon: const Icon(Icons.search),
                      color: Color.fromARGB(255, 103, 58, 183),
                      onPressed: () {
                        print('Search button pressed');
                      },
                    )
                  ])),
            )));
  }
}

Widget _buildUsers(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('logins').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Image.asset('images/animated_loading.gif');

      return _buildList(context, snapshot.data.docs);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.0,
              headingRowHeight: 30.0,
              columns: [
                DataColumn(label: Text('Display Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Password')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('uid')),
                DataColumn(label: Text('Date Created')),
              ],
              rows: snapshot
                  .map((data) => _buildListItem(context, data))
                  .toList(),
            ))
      ]));
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = LoginInfo.fromSnapshot(data);

  return DataRow(cells: [
    DataCell(Text(record.displayname), showEditIcon: false, onTap: () {
      print(record.email);
    }),
    DataCell(Text(record.email), showEditIcon: false, onTap: () {
      print(record.email);
    }),
    DataCell(Text(record.password), showEditIcon: false, onTap: () {
      print(record.password);
    }),
    //ROLE ICON
    DataCell(Icon(Icons.admin_panel_settings)),

    DataCell(Text(record.role), showEditIcon: false, onTap: () {
      print(record.role);
    }),
    DataCell(Text(record.uid), showEditIcon: false, onTap: () {
      print(record.uid);
    }),
    DataCell(Text(record.datecreated), showEditIcon: false, onTap: () {
      print(record.datecreated);
    }),
  ]);
}

class LoginInfo {
  final String displayname;
  final String email;
  final String password;
  final String role;
  final String uid;
  final String datecreated;
  final DocumentReference reference;

  LoginInfo.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['display_name'] != null),
        assert(map['email'] != null),
        assert(map['password'] != null),
        assert(map['role'] != null),
        assert(map['uid'] != null),
        assert(map['date_created'] != null),
        displayname = map['display_name'],
        email = map['email'],
        password = map['password'],
        role = map['role'],
        uid = map['uid'],
        datecreated = map['date_created'];

  LoginInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$displayname:$email:$password:$role:$uid:$datecreated>";
}

class NewLoginPopup extends StatefulWidget {
  @override
  _NewLoginPopupState createState() => _NewLoginPopupState();
}

class _NewLoginPopupState extends State<NewLoginPopup> {
  int role_selected = -1.obs;
  final new_login_displayname = TextEditingController();
  final new_login_email = TextEditingController();
  final new_login_password = TextEditingController();

  final allroles = ['New', 'Setter', 'Sales Rep', 'Manager', 'Admin'];
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      title: new Text('Create New User Login'),
      children: <Widget>[
        new SimpleDialogOption(
          child: new TextField(
            controller: new_login_displayname,

            ///CONTROLLER
            decoration: InputDecoration(hintText: 'Display Name'),
          ),
        ),
        new SimpleDialogOption(
          child: new TextField(
            controller: new_login_email,

            ///CONTROLLER
            decoration: InputDecoration(hintText: 'Email'),
          ),
        ),
        new SimpleDialogOption(
          child: new TextField(
            controller: new_login_password,

            ///CONTROLLER
            decoration: InputDecoration(hintText: 'Password'),
          ),
        ),
        new SimpleDialogOption(
            child: Center(
                child: Wrap(children: [
          ChoiceChip(
            label: Text('New'),
            selected: role_selected == 0,
            onSelected: (value) {
              setState(() {
                role_selected = value ? 0 : -1;
              });
            },
          ),
          const SizedBox(width: 6),
          ChoiceChip(
            label: Text('Setter'),
            selected: role_selected == 1,
            onSelected: (value) {
              setState(() {
                role_selected = value ? 1 : -1;
              });
            },
          ),
          const SizedBox(width: 6),
          ChoiceChip(
            label: Text('Sales Rep'),
            selected: role_selected == 2,
            onSelected: (value) {
              setState(() {
                role_selected = value ? 2 : -1;
              });
            },
          ),
          const SizedBox(width: 6),
          ChoiceChip(
            label: Text('Manager'),
            selected: role_selected == 3,
            onSelected: (value) {
              setState(() {
                role_selected = value ? 3 : -1;
              });
            },
          ),
          const SizedBox(width: 6),
          ChoiceChip(
            label: Text('Admin'),
            selected: role_selected == 4,
            onSelected: (value) {
              setState(() {
                role_selected = value ? 4 : -1;
              });
            },
          ),
        ]))),
        new SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
                color: Color.fromRGBO(103, 58, 183, 1),
                child: Text("Add New Customer",
                    style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () async {
                  //TRY ADDING NEW HERE
                  try {
                    String newLoginUID;
                    try {
                      var yeet = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: new_login_email.text,
                              password: new_login_password.text);

                      print('new loging CREATED SUCCESSFULLY');
                      newLoginUID = yeet
                          .user.uid; // CHECK IF THIS IS GOOD IF NOT DONT ADD
                    } catch (err) {
                      var errorCode = err.code;
                      var errorMessage = err.message;

                      print('ERROR CREATING AUTH LOGIN => ' +
                          errorCode +
                          ' ||| ' +
                          errorMessage);
                    }

                    final Map<String, dynamic> newLoginData =
                        new Map<String, dynamic>();

                    newLoginData['display_name'] = new_login_displayname.text;
                    newLoginData['email'] = new_login_email.text;
                    newLoginData['password'] = new_login_password.text;
                    newLoginData['role'] = allroles[role_selected];
                    newLoginData['avatar_url'] = '';
                    newLoginData['uid'] =
                        newLoginUID; //needs to be same as Auth ID
                    newLoginData['date_created'] = '10/22/20';

                    var db = FirebaseFirestore.instance.collection("logins");
                    db.doc(newLoginUID).set(newLoginData);

                    Navigator.pop(context, true);
                    print('email: ' +
                        new_login_email.text +
                        ' ||| password: ' +
                        new_login_password.text +
                        ' ||| role: ' +
                        allroles[role_selected]);
                    //  createSnackBar(
                    //       context, 'new customer added!!!');
                    //Close Dialog
                  } catch (e) {
                    //EXCEPTION!
                    // Navigator.pop(context, true);
                    //   createSnackBar(context, 'error!!');
                  }
                }))
      ],
    );
  }
}
