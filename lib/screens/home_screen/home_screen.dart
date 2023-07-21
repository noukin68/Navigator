import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  YandexMapController? yandexMapController;
  PlacemarkMapObject? userPlacemark;

  @override
  void initState() {
    super.initState();

    // Запросить разрешение на геолокацию
    Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 192, 128, 1),
        title: const Text(
          'Карта',
          style: TextStyle(
            color: Color.fromRGBO(66, 56, 46, 1),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(66, 56, 46, 1),
        ),
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              yandexMapController = controller;

              // Установить центр карты на Донской
              yandexMapController?.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(
                      latitude: 53.97,
                      longitude: 38.33,
                    ),
                    zoom: 14.0,
                  ),
                ),
              );
            },
            mapObjects: [
              if (userPlacemark != null) userPlacemark!,
            ],
          ),
          Positioned(
            left: 16.0,
            bottom: 40.0,
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(226, 192, 128, 1),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  Position position = await Geolocator.getCurrentPosition();

                  // Создать метку пользователя
                  setState(() {
                    userPlacemark = PlacemarkMapObject(
                      mapId: const MapObjectId('user_placemark'),
                      point: Point(
                        latitude: position.latitude,
                        longitude: position.longitude,
                      ),
                      opacity: 0.8,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              'assets/images/location.png'),
                        ),
                      ),
                    );
                  });

                  yandexMapController?.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: Point(
                          latitude: position.latitude,
                          longitude: position.longitude,
                        ),
                        zoom: 14.0,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(226, 192, 128, 1),
                  foregroundColor: const Color.fromRGBO(66, 56, 46, 1),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  elevation: 0,
                ),
                child: const Icon(Icons.location_pin),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: const Color.fromRGBO(159, 182, 156, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                // Обработчик нажатия для первой кнопки
              },
            ),
            IconButton(
              icon: const Icon(Icons.route),
              color: Colors.white,
              onPressed: () {
                // Обработчик нажатия для второй кнопки
              },
            ),
            IconButton(
              icon: const Icon(Icons.voice_chat),
              color: Colors.white,
              onPressed: () {
                // Обработчик нажатия для третьей кнопки
              },
            ),
          ],
        ),
      ),
    );
  }
}
