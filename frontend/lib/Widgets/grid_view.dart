import 'package:flutter/material.dart';

class GridViewBuilder {
  static Widget build(BuildContext context, List<Widget> cards) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: screenWidth < 600 ? 2 : 3,
      crossAxisSpacing: screenWidth * 0.02,
      mainAxisSpacing: screenWidth * 0.02,
      childAspectRatio: 1,
      children: cards,
    );
  }


}