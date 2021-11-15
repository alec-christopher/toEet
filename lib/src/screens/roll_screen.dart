import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_eat/blocs/application_bloc.dart';

class RollScreen extends StatefulWidget {
  const RollScreen({Key? key}) : super(key: key);

  @override
  _RollScreenState createState() => _RollScreenState();
}

class _RollScreenState extends State<RollScreen> {
  late ConfettiController _controllerCenterLeft;
  @override
  void initState() {
    super.initState();
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 1));
  }
  @override
  void dispose() {
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin the Wheel'),
        actions: const [
        ],
        backgroundColor: Color(0xFF568EA6),
      ),
      backgroundColor: Color(0xFFfffaf5),
      body: Stack(
        children: [
        Column(
          children: [
            /*Expanded(
                child: ListWheelScrollView(
                  itemExtent: 30,
                  children: applicationBloc.wheelItems
                ),
            ),*/
            Expanded(
              child:
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if(scrollNotification is ScrollEndNotification){
                    _controllerCenterLeft.play();
                  }
                  return true;
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 75,
                  useMagnifier: true,
                  magnification: 1.2,
                  offAxisFraction: .5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: applicationBloc.wheelItems,
                  ),

                ),
              ),
            ),

          ],
        ),
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _controllerCenterLeft,
              blastDirection: 0, // radial value - RIGHT
              emissionFrequency: 0.6,
              minimumSize: const Size(10,
                  10), // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(25,
                  25), // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 1,
              gravity: 0.1,
            ),
          ),
        ]
      ),
    );
  }
}
