import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_fit_flutter/states/user_state.dart';

class ProfileCard extends StatelessWidget {
  final String? name;
  final String email;
  final String? imageUrl;
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                        '$imageUrl',
                        width: 200.0, // Set the width as needed
                        height: 200.0, // Set the height as needed
                        fit: BoxFit.cover, // Adjust the fit as needed
                      )
                    : Container(
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
