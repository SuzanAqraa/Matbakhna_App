import 'package:flutter/material.dart' hide Card;

import '../../../core/widgets/SimpleAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../../../core/widgets/card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        appBar: const CustomAppBar(
          title: 'الوصفات المفضلة',
          showBackButton: false,
        ),
        body:Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: 300,
                  child:CardListing (
                    imageUrl: 'assets/images/imgesrecipe.jpg',
                    title: 'ملوخية',
                    description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                    time: '٤٥ دقيقة',
                  ),
                ),


                SizedBox(

                  height: 300,
                  child: CardListing (
                    imageUrl: 'assets/images/imgesrecipe.jpg',
                    title: 'ملوخية',
                    description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                    time: '٤٥ دقيقة',
                  ),
                ),
                SizedBox(

                  height: 300,
                  child: CardListing (
                    imageUrl: 'assets/images/imgesrecipe.jpg',
                    title: 'ملوخية',
                    description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                    time: '٤٥ دقيقة',
                  ),
                ),

              ],
            ),
          ),
        ),



        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),

      ),
    );
  }
}