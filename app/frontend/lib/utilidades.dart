

import 'package:flutter/material.dart';

snackbarError(BuildContext context,String mensaje)
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 2),
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(235, 23, 65, 0.92),
            borderRadius: BorderRadius.all(Radius.circular(29)),

          ),
          child: Text(mensaje),
        )),
  );
}