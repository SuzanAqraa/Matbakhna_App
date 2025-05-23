import 'package:flutter/material.dart';
import '../../../core/widgets/PrimaryAppBar.dart';
import '../../../core/widgets/card.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HomeAppBar(title: 'صفحة التصفح'),


              SizedBox(
                height: 300,
                child: CardListing(
                  imageUrl: 'assets/images/imges12.jpg',
                  title: 'ملوخية',
                  description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                  time: '٤٥ دقيقة',
                ),
              ),


              SizedBox(

                height: 300,
                child: CardListing(
                  imageUrl: 'assets/images/imges12.jpg',
                  title: 'ملوخية',
                  description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                  time: '٤٥ دقيقة',
                ),
              ),
              SizedBox(

                height: 300,
                child: CardListing(
                  imageUrl: 'assets/images/imges12.jpg',
                  title: 'ملوخية',
                  description: ' طبق شعبي شهير , تتكون من أوراق الملوخية  المطهية مع مرق الدجاج أو اللحم',
                  time: '٤٥ دقيقة',
                ),
              ),

            ],
          ),
        ),
      ),

    );

  }
}