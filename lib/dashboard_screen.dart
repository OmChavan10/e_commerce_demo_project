import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 15),
                Container(
                  height: 52,
                  width: 52,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,

                    // borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcYZyuDJ8-GqVTA8JuhgHaMOQQbR8M5nvuFYoO6ekyEg&s=10",
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: GoogleFonts.gabarito(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "Om Chavan",
                      style: GoogleFonts.gabarito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 100),
                Icon(Icons.favorite_outline_rounded, size: 30),
                SizedBox(width: 15),
                Icon(Icons.shopping_cart_outlined, size: 30),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search by Keywords",
                  prefixIcon: Row(
                    children: [
                      SizedBox(width: 10),
                      SvgPicture.asset(
                        "assets/search-icon(2).svg",
                        height: 22,
                        width: 22,
                      ),
                    ],
                  ),
                  suffixIcon: Row(),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
