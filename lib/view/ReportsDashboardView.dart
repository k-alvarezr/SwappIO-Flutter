import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewModel/ConnectivityServiceViewModel.dart';

class ReportsDashboardView extends StatefulWidget {
  const ReportsDashboardView({super.key});

  @override
  State<ReportsDashboardView> createState() => _ReportsDashboardViewState();
}

class _ReportsDashboardViewState extends State<ReportsDashboardView> {
  bool _isOnline = true;
  final ConnectivityServiceViewModel _connectivityService = ConnectivityServiceViewModel();

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _connectivityService.connectivityStream.listen((status) {
      setState(() => _isOnline = status);
    });
  }

  void _checkInitialConnection() async {
    bool status = await _connectivityService.isConnected;
    setState(() => _isOnline = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Reportes')),
      body: Column(
        children: [
          // ESCENARIO OFFLINE: Banner de advertencia
          if (!_isOnline)
            Container(
              color: Colors.orange.shade800,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Modo Offline: Mostrando datos en caché',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('BQ6: Funcionalidades menos usadas'),
                _buildBarChart(),
                const SizedBox(height: 30),

                _buildSectionTitle('BQ9: Demanda vs Oferta por Categoría'),
                _buildPieChart(),
                const SizedBox(height: 30),

                _buildSectionTitle('BQ10: Rendimiento de Pantallas'),
                _buildConversionTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // BQ6: Gráfico de Barras
  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.red)]), // Donar
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: Colors.blue)]), // Buscar
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2, color: Colors.red)]), // Ajustes
          ],
        ),
      ),
    );
  }

  // BQ9: Gráfico de Torta
  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: 40, title: 'Ropa', color: Colors.green, radius: 50),
            PieChartSectionData(value: 30, title: 'Hogar', color: Colors.orange, radius: 50),
            PieChartSectionData(value: 15, title: 'Juguetes', color: Colors.purple, radius: 50),
          ],
        ),
      ),
    );
  }

  // BQ10: Tabla de Conversión
  Widget _buildConversionTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: const [
        TableRow(children: [
          Padding(padding: EdgeInsets.all(8), child: Text('Pantalla', style: TextStyle(fontWeight: FontWeight.bold))),
          Padding(padding: EdgeInsets.all(8), child: Text('Tiempo Prom.', style: TextStyle(fontWeight: FontWeight.bold))),
          Padding(padding: EdgeInsets.all(8), child: Text('Conversión', style: TextStyle(fontWeight: FontWeight.bold))),
        ]),
        TableRow(children: [
          Padding(padding: EdgeInsets.all(8), child: Text('Home')),
          Padding(padding: EdgeInsets.all(8), child: Text('2.5 min')),
          Padding(padding: EdgeInsets.all(8), child: Text('15%')),
        ]),
        TableRow(children: [
          Padding(padding: EdgeInsets.all(8), child: Text('Detalle Producto')),
          Padding(padding: EdgeInsets.all(8), child: Text('4.1 min')),
          Padding(padding: EdgeInsets.all(8), child: Text('45%')),
        ]),
      ],
    );
  }
}