import 'package:flutter/material.dart';

Widget buildNutrientCard(String title, double remaining, double consumed,
    bool arrowback, bool arrowforward) {
  final double total = remaining + consumed;
  final double progress = consumed / total;
  final bool goalReached = remaining <= 0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            arrowback == true
                ? Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                  )
                : Container(),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            arrowforward == true
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  )
                : Container(),
          ])),
      ListTile(
        title: goalReached
            ? Text('Objetivo cumplido', style: TextStyle(color: Colors.green))
            : LinearProgressIndicator(
                value: progress,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.grey[300],
              ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          remaining >= 0
              ? Text(
                  'Faltan: ${remaining.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )
              : Text(
                  'Faltan: 0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
          SizedBox(width: 10),
          Text(
            ' Consumidas ${consumed.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}
