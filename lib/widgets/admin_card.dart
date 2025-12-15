import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final Widget? action;
  final bool expandChild;

  const AdminCard({
    super.key,
    required this.child,
    this.padding,
    this.title,
    this.action,
    this.expandChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card (Jika ada Judul)
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF2)),
          ],

          // Isi Card
          if (expandChild)
            Expanded(child: child)
          else
            Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
        ],
      ),
    );
  }
}