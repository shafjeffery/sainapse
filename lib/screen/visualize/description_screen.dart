import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ar_model.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513), // Dark brown background
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFF9DB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Description',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFFFFF9DB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Main content card
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFFF9DB), // Light yellow
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Text(
                          'Heart',
                          style: GoogleFonts.museoModerno(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Description
                      Text(
                        'The heart is a muscular organ located slightly to the left of the chest. Its main function is to pump blood throughout the body, supplying oxygen and nutrients while removing waste products like carbon dioxide.',
                        style: GoogleFonts.museoModerno(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      
                      // Additional information
                      Text(
                        'Key Features:',
                        style: GoogleFonts.museoModerno(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      _buildFeatureItem('• Four chambers: two atria and two ventricles'),
                      _buildFeatureItem('• Valves that prevent backflow of blood'),
                      _buildFeatureItem('• Electrical conduction system for rhythm'),
                      _buildFeatureItem('• Coronary arteries supply blood to heart muscle'),
                      
                      const Spacer(),
                      
                      // AR Button
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E23).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ArModel(),
                                ),
                              );
                            },
                            child: Text(
                              'AR',
                              style: GoogleFonts.museoModerno(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6B8E23),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.museoModerno(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
