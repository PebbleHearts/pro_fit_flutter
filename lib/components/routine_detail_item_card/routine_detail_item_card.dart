import 'package:flutter/material.dart';

class RoutineDetailItemCard extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool displayCta;
  const RoutineDetailItemCard({
    super.key,
    required this.name,
    this.onTap,
    this.onDelete,
    required this.displayCta,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 6, bottom: 6, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  if (displayCta)
                    Row(
                      children: [
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: IconButton(
                            onPressed: () {
                              onDelete!();
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
