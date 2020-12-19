
import 'package:flutter/material.dart';



Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    
      
             
   
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

// ignore: unused_element
PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}

