import 'package:flutter/material.dart';

class SplashBody extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
            ),
            Text("مطبخنا" ,style:
            TextStyle(fontSize: 54,
                fontWeight:FontWeight.bold,
                color: Color(0xFF33363F),
                fontFamily: 'Tajawal'),),
          ],
        ),
      ),
    );





  }
}