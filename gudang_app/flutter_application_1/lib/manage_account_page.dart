import 'package:flutter/material.dart';
import 'manage_account_page.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  // Data Dummy Akun
  List<Map<String, String>> users = [
    {"name": "Budi Santoso", "role": "Operator In"},
    {"name": "Siti Aminah", "role": "Operator Out"},
    {"name": "Joko Anwar", "role": "Admin Gudang"},
  ];

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        return AlertDialog(
          title: const Text("Tambah Akun"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Nama Operator"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.add({"name": nameController.text, "role": "Operator"});
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Akun")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(users[index]["name"]![0])),
              title: Text(users[index]["name"]!),
              subtitle: Text(users[index]["role"]!),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
