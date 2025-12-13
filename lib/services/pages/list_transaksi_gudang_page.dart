import 'package:flutter/material.dart';
import '../stock_reservation_service.dart';

class ListTransaksiGudangPage extends StatefulWidget {
  final String token;
  const ListTransaksiGudangPage({super.key, required this.token});

  @override
  State<ListTransaksiGudangPage> createState() =>
      _ListTransaksiGudangPageState();
}

class _ListTransaksiGudangPageState
    extends State<ListTransaksiGudangPage> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = StockReservationService(widget.token).fetchReservations();
  }

  Future<void> _refresh() async {
    setState(() {
      _future =
          StockReservationService(widget.token).fetchReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Transaksi Gudang"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(
              child: Text("Belum ada transaksi"),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                final r = data[i];
                final fulfilled = r['is_fulfilled'] == true;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      r['item']['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text("Qty: ${r['quantity']}"),
                        if (r['purpose'] != null)
                          Text("Catatan: ${r['purpose']}"),
                      ],
                    ),
                    trailing: fulfilled
                        ? const Chip(
                            label: Text("Fulfilled"),
                            backgroundColor:
                                Colors.greenAccent,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              final ok =
                                  await StockReservationService(
                                          widget.token)
                                      .fulfillReservation(
                                          r['id']);
                              if (ok) _refresh();
                            },
                            child: const Text("Fulfill"),
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
