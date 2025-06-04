import 'package:flutter/material.dart';
import 'listing_screen.dart';

class ListingScreenWrapper extends StatelessWidget {
  final String searchQuery;

  const ListingScreenWrapper({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ListingScreen(searchQuery: searchQuery);
  }
}
