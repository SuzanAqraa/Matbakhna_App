import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class RecipeStepPage extends StatelessWidget {
  const RecipeStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A908C),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Action for back button
          },
        ),
        title: Text('الخطوة الثانية ', textDirection: TextDirection.rtl,style: GoogleFonts.tajawal(fontSize:25,fontWeight: FontWeight.bold,color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Image.asset(
              "assets/images/cake.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  Container(
                    height:400,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [

                        Text(
                          'لوازم الخطوة',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.soup_kitchen, size: 40),
                                Text('طبق تقديم'),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.no_meals_ouline ,size: 40),
                                Text('جوز هند مبشور'),
                              ],
                            ),
                          ],

                        ),

                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          margin: const EdgeInsets.all(20),
                          child: Text(
                            'شكل العجينة كرات صغيرة ثم دحرجها في جوز الهند المبشور حتى تغطي بالكامل. ضعها في الثلاجة قليلاً لتتماسك أكثر، ثم قدمها!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, height: 1.5,fontWeight: FontWeight.bold),
                          ),),
                      ],

                    ),

                  ),


                  Center(
                    child: SizedBox(


                      child: GroupButton(
                        options: GroupButtonOptions(

                        ),
                        buttons: [
                          "1","2","3" ,"4"
                        ],

                        isRadio: false,

                        buttonBuilder: (isSelected, value, context) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            width:70,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),

                              color: isSelected ? Color(0xFF6A908C) : Color(
                                  0xFF99AFAD),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical:12),

                            child: Text(

                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansArabic(fontSize: 25,
                                color: Color(0xFF000000),),


                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),






    );
  }

}


class StepIndicator extends StatelessWidget {
  final int number;
  final bool isActive;

  const StepIndicator({super.key, required this.number, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: isActive ? Colors.teal : Colors.grey.shade300,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 20,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );

  }
}
