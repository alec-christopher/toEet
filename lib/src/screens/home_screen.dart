
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_eat/blocs/application_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);
    void _onMapCreated(GoogleMapController _controller)
    {
     applicationBloc.setCurrentLocation();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('toEat'),
        backgroundColor: const Color(0xFF568EA6),

      ),
      backgroundColor: const Color(0xFFfffaf5),
      floatingActionButton: SpeedDial(
        backgroundColor: const Color(0xFF568EA6),
        childMargin: const EdgeInsets.all(10),

        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: "Spin",
            child: const Icon(Icons.auto_awesome),
            onTap: (){ Navigator.pushNamed(context, '/roll');},
            backgroundColor: const Color(0xFFF0b7a4),
          ),
          SpeedDialChild(
            label: "Filters",
            child: const Icon(Icons.filter_alt),
            onTap: (){ Navigator.pushNamed(context, '/filter');},
            backgroundColor: const Color(0xFFF0b7a4),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude),
                      zoom: 12,
                    ),
                    onMapCreated: _onMapCreated,
                    zoomControlsEnabled: false,
                    markers: applicationBloc.markers,
                    mapToolbarEnabled: false,
                    buildingsEnabled: false,
                    myLocationButtonEnabled: false,
                    circles:{Circle(
                      circleId: const CircleId("home"),
                      center: LatLng(applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude),
                      radius: applicationBloc.getSliderValue()* 1600,
                      fillColor: const Color(0x77F1D1B5),
                      strokeColor: Colors.transparent,
                    )},
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
            height: 75,
            padding: const EdgeInsets.all(3),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: applicationBloc.selections.length,
              itemExtent: 100,
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(
                    applicationBloc.selections[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  backgroundColor: const Color(0xFF568EA6),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
