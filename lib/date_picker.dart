import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_apod/json_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  DateTime selectedDate = DateTime.now();
  var newFormat = DateFormat('d MMM y');


    _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate)

        selectedDate = pickedDate;
  }

  Future<Astrology> getNews() async {
    String selected = "${selectedDate.toLocal()}".split(' ')[0];
    var jsonResponse = await http.get(
      Uri.parse(
          'https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date=$selected'),
    );
    final newData = json.decode(jsonResponse.body);
    Astrology astrology = Astrology.fromJson(newData);
    return astrology;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        // Refer step 3
                        child: Text(
                          'Pick Date',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            getNews();
                          });
                        },
                        child: Text(
                          'Find',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),

                  FutureBuilder<Astrology>(
                    future: getNews(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError)
                          return Center(child: Text('Error: ${snapshot.error}'));
                        else
                          return Center(
                            child: Text(
                              '${snapshot.data.title}',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${newFormat.format(selectedDate)}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 40),
                  FutureBuilder<Astrology>(
                      future: getNews(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 6.0),
                                  ],),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        '${snapshot.data.hdurl}',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  snapshot.data.copyright != null? Text('Copyright: ${snapshot.data.copyright}') : Container(),
                                ],
                              ),
                            );
                          }
                        }
                      }),
                  SizedBox(
                    height: 100,
                  ),

                  FutureBuilder<Astrology>(
                    future: getNews(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError)
                          return Center(child: Text('Error: ${snapshot.error}'));
                        else
                          return Center(
                            child: Text(
                              '${snapshot.data.explanation}', //from the future function
                              style: TextStyle(fontSize: 15, letterSpacing: 1.5, height: 2),
                              // maxLines: 5,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          );
                      }
                    },
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
