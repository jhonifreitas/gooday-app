import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartCustom extends StatelessWidget {
  const LineChartCustom({required this.lineBarsData, super.key});

  final List<LineChartBarData> lineBarsData;

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    String text = '';

    switch (value.toInt()) {
      case 54:
        text = '54';
        break;
      case 70:
        text = '70';
        break;
      case 180:
        text = '180';
        break;
      case 250:
        text = '250';
        break;
      case 400:
        text = '400';
        break;
      default:
        return const SizedBox();
    }

    return Text(text, style: const TextStyle(fontSize: 10));
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    String text = '';

    switch (value.toInt()) {
      case 1:
        text = 'Jan';
        break;
      case 2:
        text = 'Fev';
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Abr';
        break;
      case 5:
        text = 'Mai';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Ago';
        break;
      case 9:
        text = 'Set';
        break;
      case 10:
        text = 'Out';
        break;
      case 11:
        text = 'Nov';
        break;
      case 12:
        text = 'Dez';
        break;
      default:
        return const SizedBox();
    }

    return Text(text, style: const TextStyle(fontSize: 12));
  }

  List<LineTooltipItem?> _getTooltipItems(List<LineBarSpot> lineBarsSpot) {
    return lineBarsSpot.map((lineBarSpot) {
      return LineTooltipItem(
        NumberFormat().format(lineBarSpot.y),
        const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        lineBarsData: lineBarsData,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,
            getTooltipItems: _getTooltipItems,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: _leftTitleWidgets,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: _bottomTitleWidgets,
            ),
          ),
        ),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 0,
              y2: 54,
              color: Colors.red.shade900.withAlpha(80),
            ),
            HorizontalRangeAnnotation(
              y1: 54,
              y2: 70,
              color: Colors.red.shade300.withAlpha(80),
            ),
            HorizontalRangeAnnotation(
              y1: 70,
              y2: 180,
              color: Colors.green.withAlpha(80),
            ),
            HorizontalRangeAnnotation(
              y1: 180,
              y2: 250,
              color: Colors.yellow.withAlpha(80),
            ),
            HorizontalRangeAnnotation(
              y1: 250,
              y2: 400,
              color: Colors.orange.withAlpha(80),
            ),
          ],
        ),
      ),
    );
  }
}
