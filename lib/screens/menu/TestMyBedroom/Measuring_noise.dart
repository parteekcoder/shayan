import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:night_gschallenge/providers/light_provider.dart';
import 'package:night_gschallenge/providers/noise_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class MeasuringNoise extends StatefulWidget {

  @override
  _MeasuringNoiseState createState() => _MeasuringNoiseState();
}

class _MeasuringNoiseState extends State<MeasuringNoise> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Center(
            child: Text(
              'Keep your phone steady',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Image.asset(
            'assets/scanload.gif',
            fit: BoxFit.cover,
          ),
          Center(
            child: Consumer<NoiseProvider>(
              builder: (context, value, child) {
                return Text(
                  '${value.db} dB',
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
