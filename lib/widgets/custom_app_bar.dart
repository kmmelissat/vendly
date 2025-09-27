import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset('assets/images/vendly.svg', height: 50),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
