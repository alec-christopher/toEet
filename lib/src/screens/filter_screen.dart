import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_eat/blocs/application_bloc.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        backgroundColor: Color(0xFF568EA6),
      ),
      backgroundColor: Color(0xFFfffaf5),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Restaraunt/Food filter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF568EA6),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "One word search terms",
                        suffixIcon: Icon(Icons.add),
                      ),
                      onSubmitted: (value){
                        if(applicationBloc.addSelection(value.toLowerCase())) {
                          applicationBloc.addResults(
                              value, applicationBloc.sliderValue);
                        }
                        textController.clear();

                      },
                      controller: textController,
                    ),
                  ),
                  const Text("Distance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF568EA6),
                    ),
                  ),
                  Slider(
                    onChanged: (double value) {
                      applicationBloc.setSlider(value);
                      applicationBloc.distanceReset();
                    },
                    value: applicationBloc.sliderValue,
                    max: 20,
                    divisions: 10,
                    label: "${applicationBloc.sliderValue}",
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: applicationBloc.selections.length,
                    itemBuilder: (context, index){
                      return Chip(
                        padding: const EdgeInsets.all(5),
                        label: Text(applicationBloc.selections[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        onDeleted: () {
                          var type = applicationBloc.selections[index];
                          applicationBloc.removeSelection(index);
                          applicationBloc.removeResults(type);
                          //applicationBloc.redrawMarkers();
                        },
                        deleteIcon: Icon(Icons.close, color: Colors.white,),
                        backgroundColor: Color(0xFF568EA6),
                      );
                    },
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
