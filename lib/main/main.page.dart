import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_slider/main/bloc/bloc.dart';

const int NUM_PIES = 30;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainBloc mainBloc;

  @override
  void initState() {
    this.mainBloc = MainBloc();
    super.initState();
  }

  @override
  void dispose() {
    this.mainBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => this.mainBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PIE CHART'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 500,
              child: BlocBuilder<MainBloc, MainState>(
                bloc: this.mainBloc,
                builder: (_, state) {
                  return GridView.count(
                    crossAxisCount: 5,
                    children: List.generate(
                      30,
                      (idx) => charts.PieChart(
                        [
                          charts.Series<LinearSales, int>(
                            id: 'Sales',
                            domainFn: (LinearSales sales, _) => sales.year,
                            measureFn: (LinearSales sales, _) => sales.sales,
                            data: [
                              new LinearSales(
                                  0,
                                  (state.counter * (NUM_PIES - idx) / NUM_PIES + (300 - state.counter) * idx / NUM_PIES)
                                      .round()),
                              new LinearSales(
                                  1,
                                  300 -
                                      (state.counter * (NUM_PIES - idx) / NUM_PIES +
                                              (300 - state.counter) * idx / NUM_PIES)
                                          .round()),
                            ],
                          ),
                        ],
                        animate: false,
                        defaultRenderer: charts.ArcRendererConfig(
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.auto)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StatefulSlider(
              onChanged: (val) => this.mainBloc.dispatch(IncrementEvent(val)),
            )
          ],
        ),
      ),
    );
  }
}

class StatefulSlider extends StatefulWidget {
  final Function(double) onChanged;

  const StatefulSlider({Key key, this.onChanged}) : super(key: key);

  @override
  _StatefulSliderState createState() => _StatefulSliderState();
}

class _StatefulSliderState extends State<StatefulSlider> {
  double _val = 0;

  void newValue(double val) {
    setState(() {
      _val = val;
      if (widget.onChanged != null) {
        widget.onChanged(val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0,
      max: 300,
      value: _val,
      onChanged: (val) => newValue(val),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
