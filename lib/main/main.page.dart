import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_slider/main/bloc/bloc.dart';

const NUM_PIES = 29;
const double TOTAL_VALUE_CHART = 1000000.0;

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
                    children: List.generate(NUM_PIES + 1 , (idx) {
                      final val1 = (state.counter * (NUM_PIES - idx) / NUM_PIES + (1 - state.counter) * idx / NUM_PIES) * TOTAL_VALUE_CHART;
                      return charts.PieChart(
                        [
                          charts.Series<LinearSales, int>(
                            id: 'Sales',
                            domainFn: (LinearSales sales, _) => sales.year,
                            measureFn: (LinearSales sales, _) => sales.sales,
                            data: [
                              LinearSales(0, val1),
                              LinearSales(1, TOTAL_VALUE_CHART - val1),
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
                    }),
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
      max: 1,
      value: _val,
      onChanged: (val) => newValue(val),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final double sales;

  LinearSales(this.year, this.sales);
}
