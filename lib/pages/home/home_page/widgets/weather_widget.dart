import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../network/model/Weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: WeatherBg(
            colorOpacity: .5,
            cloudOpacity: .4,
            weatherType: weather.current.is_day == 0
                ? WeatherType.sunnyNight
                : WeatherType.cloudy,
            width: width,
            height: height / 5,
          ),
        ),
        Positioned(
          top: 0 ,
          child: SizedBox(

            width: width,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        "https://${weather.current.condition.icon.substring(2)}",
                        width: width / 5,
                        height: width / 5,
                      ),
                      Text(
                        "${weather.current.temp_c}℃",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    weather.location.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weather.location.country,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weather.current.condition.text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
