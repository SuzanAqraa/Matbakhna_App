import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
class imgesWidget extends StatelessWidget {
  final List<String> imagesList = [
    'assets/images/imageview1.jpg',
    'assets/images/imagereview2.jpg',
    'assets/images/imagereview3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: CarouselSlider(
            items: imagesList.map((image) {
              return Container(
                  margin: EdgeInsets.all(15.0),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                child: Image.asset(image,
                  fit: BoxFit.cover, width: 400,),
              )

              );
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: 500,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 8),

            ),
          ),
        ),
Padding(padding: const EdgeInsets.all(10.0),

child: Text("مطبخنا",
    style:GoogleFonts.elMessiri(
      fontSize: 45,fontWeight:FontWeight.bold,color: Color(0xFF33363F),
    ) , ),
),

        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Directionality(
            textDirection: TextDirection.rtl, //
            child: Text(
              "يقدم وصفات أكل متنوعة وشهية بتعليمات دقيقة وصور جذابة. يتميز ببحث ذكي ونصائح مفيدة، مما يجعله رفيقًا مثاليًا لكل مستويات الطهاة.",
              textAlign: TextAlign.justify, // تنسيق النص
              softWrap: true, // كسر الأسطر تلقائيًا
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.elMessiri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33363F),
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(25.0),
       child: ElevatedButton(
          style: ElevatedButton.styleFrom(
             backgroundColor: Color(0xFFA5C8A6),
              textStyle: const TextStyle(fontSize: 25),
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 125)),
          onPressed: () {},
          child: const Text("اكتشف معنا",style: TextStyle(fontWeight:FontWeight.bold,color: Color(0xFF33363F) ,fontFamily: 'Tajawal',),),
        ), ),
    ],
    );
  }
}