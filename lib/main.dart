///Works Cited:
///Flutter - Build An App To Fetch Data Online Using HTTP GET | Android & iOS =
///https://www.youtube.com/watch?v=aIJU68Phi1w

import 'package:flutter/material.dart';
import 'models/TestModel/TestCollectionObject.dart';
import 'api_services/test_collection_service/test_collection_service.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //These 2 controllers are what give access to the data in the TextFormField() fields.
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();// allows for form validation and submitting.
  List<dynamic> _listOfNames; //gets the TestCollectionObject from the getJson() call.

  @override
  void initState() {//Code to run when the app loads.
    super.initState();
    _getJsonData('http://localhost:60000/test/tests');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Json via all 4 CRUD operations'),
      ),
      body: GestureDetector(//Allows for the TextFormField fields to be deselected when the user taps outside of
        //the text box.
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Builder(
                  builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(//Required when using text fields within a Row widget
                              child: TextFormField(
                                controller: _firstNameCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'First name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your first name.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(//Required when using text fields within a Row widget
                              child: TextFormField(
                                controller: _lastNameCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Last name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your last name.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Add Name'),
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save(); //save data to local variables.
                                  await TestCollectionService.postJsonData(
                                      //Push data to API
                                      'http://localhost:60000/test/tests',
                                      _firstNameCtrl.text,
                                      _lastNameCtrl.text);
                                  await _getJsonData(//Refreshes data.
                                      'http://localhost:60000/test/tests');
                                  setState(() {//Refreshes data.
                                    //
                                  });
                                  //automatically close keyboard.
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    //Calculates the height of the device screen, then makes that number smaller
                    //in order to have room for the text entry form to be on top, and give the rest of
                    //the height to the list view.
                    maxHeight: MediaQuery.of(context).size.height * 0.65,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true, // this line is very important.
                    itemCount: _listOfNames == null ? 0 : _listOfNames.length,
                    itemBuilder: (buildContext, int index) {
                      return Container(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _firstNameCtrl.text = _listOfNames[index].getFirstName();
                                  _lastNameCtrl.text = _listOfNames[index].getLastName();
                                },
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      //Makes the text be on the left and the buttons be on the right.
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(_listOfNames[index].getFirstName() + ' ' + _listOfNames[index].getLastName()),
                                        RaisedButton(
                                          child: Text('Update'),
                                          onPressed: () async {
                                            _listOfNames[index].setFirstName(_firstNameCtrl.text);
                                            _listOfNames[index].setLastName(_lastNameCtrl.text);
                                            await TestCollectionService.putJsonData(
                                                'http://localhost:60000/test/tests', _listOfNames[index]);
                                            //Refreshes data.
                                            await _getJsonData('http://localhost:60000/test/tests');
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text('Delete'),
                                          onPressed: () async {
                                            String deleteUrl = 'http://localhost:60000/test/testDelete/';
                                            await TestCollectionService.deleteJsonData(deleteUrl, _listOfNames[index]);
                                            //Refreshes data.
                                            await _getJsonData('http://localhost:60000/test/tests');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, // item builder
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //**REMEMBER, you will need to call the Flutter setState() method to refresh the list of objects
  //displayed from the database.

  //Takes a url and returns an object to the calling widget and a reference to the object that will
  //contain the data in the parent.
  Future _getJsonData(String url) async {
    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url),
        //only accept json response
        headers: {"Accept": "application/json"});
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print('Successful Get.');
      var convertDataToJson2 = json.decode(response.body);
      List<dynamic> responses = convertDataToJson2
          .map((j) => TestCollectionObject.fromJson(j))
          .toList();

      setState(() {
        this._listOfNames = responses;
      });
      return 'Successful Get.';
    } else {
      print('Failed Get.');
      return 'Failed Get.';
    }
  }
}
