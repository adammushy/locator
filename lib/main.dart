import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/current_location.dart';
import 'package:locator/location_services.dart';
import 'direction.dart';
import 'search_place.dart';

// import 'directions.dart';
// import 'map_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: Colors.cyan,
        primaryTextTheme: Typography.blackRedmond,
      
      ),
      // home: MapScreen(),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locator"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSample1()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(elevation: 20,
                  child: Container(
                    // padding: EdgeInsets.all(0.0),
                    height: 200,
                    width: double.infinity,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: AssetImage("assets/images/direction.jpg",),fit:BoxFit.cover )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20,left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Directions",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSample()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  child: Container(
                    // padding: EdgeInsets.all(0.0),
                    height: 200,
                    width: double.infinity,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: AssetImage("assets/images/search.jpg",),fit:BoxFit.cover )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20,left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Search Place",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrentLocationScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  child: Container(
                    // padding: EdgeInsets.all(0.0),
                    height: 200,
                    width: double.infinity,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: AssetImage("assets/images/live.jpg",),fit:BoxFit.cover )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20,left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Place",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
            
          ],
        ),
      ),

    );
  }
}



