import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper1/model/userModel.dart';

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List<String> images = [
    "https://images.pexels.com/photos/1420226/pexels-photo-1420226.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1525041/pexels-photo-1525041.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/4588065/pexels-photo-4588065.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/3136673/pexels-photo-3136673.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
  ];

  List<String> names = ["Flower", "City", "Nature", "Animal", "Car"];

  UserModel _userModel;

  Future<void> getLatestPhoto() async {
    http.Response response = await http
        .get("https://api.pexels.com/v1/curated?per_page=10&page=1", headers: {
      "Authorization":
          "563492ad6f91700001000001ca927d9083584d8ba2ada0d2c4243eba"
    });

    _userModel = UserModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "Wallpaper",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: "Store",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            padding: EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 1,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(images[index]),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        height: 150,
                        child: Text(
                          names[index],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 1.507,
              padding: EdgeInsets.all(0.0),
              child: FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: _userModel.photos.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 3.0,
                            childAspectRatio: 1,
                            mainAxisSpacing: 9.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                  child: CachedNetworkImage(
                                imageUrl: _userModel.photos[index].src.original,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Image.network(
                                    "https://cdn.onlinewebfonts.com/svg/img_148071.png"),
                              )));
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  future: getLatestPhoto())),
        ]),
      ),
    );
  }
}
// GridView.count(
// scrollDirection: Axis.horizontal,
// mainAxisSpacing: 5,
// crossAxisCount: 1,
// shrinkWrap: true,
// children: List.generate(
// 5,
// (index) {
// return Padding(
// // padding: const EdgeInsets.only(top: 40.0, left: 5.0),
// // child: Container(
// // width: 300,
// // decoration: BoxDecoration(
// // color: Colors.black,
// // image: DecorationImage(
// // image: NetworkImage('img.png'),
// // ),
// // borderRadius: BorderRadius.all(
// // Radius.circular(20.0),
// // ),
// // ),
// // ),
// // );
// },
// ),
// ),
