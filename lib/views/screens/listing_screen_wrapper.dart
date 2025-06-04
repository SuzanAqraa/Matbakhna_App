import 'package:flutter/material.dart';
import 'listing_screen.dart';

class ListingScreenWrapper extends StatelessWidget {
  const ListingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    String? searchQuery;

    if (args != null && args is String) {
      searchQuery = args;
    }

    return ListingScreen(searchQuery: searchQuery);
  }
}
