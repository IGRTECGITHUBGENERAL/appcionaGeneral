import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  final User user = FirebaseAuth.instance.currentUser!;
  late List<Marker>? markers;
  int alcance = 1;
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.4122119, -98.9913005),
    zoom: 15,
  );

  @override
  void initState() {
    markers = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, data) {
          if (data.hasData) {
            return GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: Set.from(markers!),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            );
          } else if (data.hasError) {
            return Center(
              child: Text('${data.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
