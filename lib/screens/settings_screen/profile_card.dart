import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
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
      child:  const Row(
        children: [
          SizedBox(
            width: 33,
            height: 33,
            child: Center(child: Text('img')),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nirmal Michel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'nirmalmichelp@gmail.com',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
