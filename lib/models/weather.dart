class Weather {
  final int date;
  final String description;
  final String icon;
  final double tempreature;
  final double feelsLike;
  final double humidity;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }

  Weather({
    required this.date,
    required this.description,
    required this.icon,
    required this.tempreature,
    required this.feelsLike,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      date: json['current']['dt'].toInt(),
      description: json['current']['weather'][0]['description'].toString(),
      icon: json['current']['weather'][0]['icon'],
      tempreature: json['current']['temp'].toDouble(),
      feelsLike: json['current']['feels_like'].toDouble(),
      humidity: json['current']['humidity'].toDouble(),
    );
  }
}
