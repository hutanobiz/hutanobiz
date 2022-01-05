import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/screens/appointments/video_player.dart';


class ImageSlider extends StatelessWidget {
  ImageSlider({this.imageVideoList});

  final List imageVideoList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        final double height = MediaQuery.of(context).size.height;
        return CarouselSlider(
          options: CarouselOptions(
            height: height,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            // autoPlay: false,
          ),
          items: imageVideoList
              .map((item) => Container(
                    child: Center(
                        child: item['type'] == '1'
                            ? Image.network(
                                ApiBaseHelper.image_base_url + item['url'],
                                fit: BoxFit.cover,
                                width: 1000)
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SamplePlayer(
                                        videoPath:
                                            ApiBaseHelper.image_base_url +
                                                item['url'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Icon(Icons.play_arrow_outlined),
                                ),
                              )),
                  ))
              .toList(),
        );
      },
    ));
  }
}