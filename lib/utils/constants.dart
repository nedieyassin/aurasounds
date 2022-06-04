import 'package:flutter/material.dart';

TextStyle xheading = const TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.grey
);
TextStyle xtitle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
TextStyle xsubtitle = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
);
TextStyle xbody = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

//
BoxShadow xshadow1 = BoxShadow(
  color: Colors.black.withOpacity(.1),
  spreadRadius: 1,
  blurRadius: 2,
  offset: const Offset(0, 2),
);

BoxShadow xshadow2 = BoxShadow(
  color: Colors.black.withOpacity(.1),
  spreadRadius: 1,
  blurRadius: 2,
  offset: const Offset(0, -2),
);

BorderRadius xborderRadius = const BorderRadius.all(Radius.circular(12));
BorderRadius xborderRadiusS = const BorderRadius.all(Radius.circular(9));
