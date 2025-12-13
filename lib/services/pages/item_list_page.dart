import 'package:flutter/material.dart';
import '../item_service.dart';
import 'item_edit_page.dart';

class ItemListPage extends StatefulWidget {
  final String token;
  const ItemListPage({required this.token});

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late ItemService itemService;
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(widget.token);
    fetchItems();
  }

  void fetchItems() async {
    setState(() => isLoading = true);
    items = await itemService.getItems();
    setState(() => isLoading = false);
  }

  /// ✅ FUNCTION DELETE
  void deleteItem(int id) async {
    final ok = await itemService.deleteItem(id);
    if (ok) {
      Navigator.pop(context);
      fetchItems();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Item berhasil dihapus")));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus item")));
    }
  }

  /// ✅ DIALOG KONFIRMASI
  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Item"),
        content: Text("Apakah kamu yakin ingin menghapus item ini?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Hapus"),
            onPressed: () => deleteItem(id),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Data Item",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: fetchItems)],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            )
          : items.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async => fetchItems(),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildItemCard(item, index);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "Tidak ada item",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map item, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EditItemPage(token: widget.token, itemId: item['id']),
              ),
            );
            fetchItems();
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // ICON
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[600]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inventory_2, color: Colors.white, size: 28),
                ),

                SizedBox(width: 16),

                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.qr_code,
                            "SKU: ${item['sku']}",
                            Colors.orange,
                          ),
                          SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.warehouse,
                            "Stock: ${item['stock']}",
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ EDIT + DELETE
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditItemPage(
                              token: widget.token,
                              itemId: item['id'],
                            ),
                          ),
                        );
                        fetchItems();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => confirmDelete(item['id']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}