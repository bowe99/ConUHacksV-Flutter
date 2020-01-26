import 'package:flutter/material.dart';


class ActivityCard extends StatelessWidget {
  final String name;
  final String location;

  ActivityCard(this.name, this.location);


  
  
  @override
  Widget build(BuildContext context) {
    return        Container(
                    width: 200.0,
                    child: Card(
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: Text(
                                  this.name,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(this.location),
                              )
                            ],
                          ),
                          Icon(Icons.restaurant)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  );
  }
}