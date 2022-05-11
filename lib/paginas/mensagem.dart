import 'package:flutter/material.dart';

Future<bool?> confirmar(BuildContext context, String mensagem){
  return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mensagem),
          actions: <Widget>[
            TextButton(
                child: const Text('Sim'),
                onPressed: (){
                  Navigator.pop(context, true);
                }),
            TextButton(
                onPressed: (){
                  Navigator.pop(context, false);
                },
                child: const Text('Não'))
          ],
        );
      }
  );
}

Future<void> informar (BuildContext context, String mensagem){
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(mensagem),
          actions: <Widget>[
            TextButton(
                onPressed: (){
                  Navigator.pop(context, false);
                },
                child: const Text('Ok')
            )
          ],
        );
      });
}