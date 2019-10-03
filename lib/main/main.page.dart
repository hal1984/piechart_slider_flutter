import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_slider/main/bloc/bloc.dart';

const NUM_PIES = 29;
const TOTAL_VALUE_CHART = 100;

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
              height: 440,
              child: GridView.count(
                crossAxisCount: 5,
                children: List.generate(NUM_PIES + 1, (idx) {
                  return BlocBuilder<MainBloc, MainState>(
                    bloc: this.mainBloc,
                    builder: (_, state) {
                      final val1 = (state.counter * (NUM_PIES - idx) / NUM_PIES +
                          (TOTAL_VALUE_CHART - state.counter) * idx / NUM_PIES);
                      return charts.PieChart(
                        [
                          charts.Series<LinearSales, String>(
                            id: 'Sales',
                            domainFn: (LinearSales sales, _) => sales.year,
                            measureFn: (LinearSales sales, _) => sales.sales,
                            data: [
                              LinearSales('Slider', val1.round()),
                              LinearSales('Rest', TOTAL_VALUE_CHART - val1.round()),
                            ],
                          ),
                        ],
                        animate: false,
                        defaultRenderer: charts.ArcRendererConfig(
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.auto)
                          ],
                        ),
                      );
                    },
                  );
                }),
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
      min: 0.0,
      max: TOTAL_VALUE_CHART.toDouble(),
      value: _val,
      onChanged: (val) => newValue(val),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}
