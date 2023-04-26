// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:typed_data';

// import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Post extends StatefulWidget {
  Uint8List img1;
  Uint8List img2;
  Post({required this.img1,required this.img2});
  @override
  State<Post> createState() => _PostState(img1, img2);
}

class _PostState extends State<Post> {
  Uint8List img1, img2;
  _PostState(this.img1, this.img2);
  final CarouselController controller = CarouselController();
  int i = 0;
  @override
  Widget build(BuildContext context) {
    var images = [
      Image.memory(img2,fit: BoxFit.fill),
      Image.memory(img1,fit: BoxFit.fill,),
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: ListView(children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Text(
            'Uploded Image',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: size.width,
          height: size.height/2,
          child: Image.memory(img1,fit: BoxFit.fill,)),
        const SizedBox(height: 30,),
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Text(
            'Result Image',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          width: size.width,
          height: size.height/2,
          child: Image.memory(img2,fit: BoxFit.fill,)
          ),
        // CarouselSlider.builder(
        //   itemCount: 2,
        //   itemBuilder: (context, index, realIndex) {
        //     return Container(
        //       width: 256,
        //       height: 256,
        //       child: images[index]
        //       );
        //   },
        //   options: CarouselOptions(
        //     enableInfiniteScroll: false,
        //     height: 300,
        //     viewportFraction: 1,
        //     onPageChanged: (index, reason) => setState(
        //       () {
        //         i = index;
        //       },
        //     ),
        //   ),
        // ),
        const SizedBox(
          height: 30,
        ),
        // Center(child: buildIndicator())
      ]),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: i,
        count: 2,
      );
}