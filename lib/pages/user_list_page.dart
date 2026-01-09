import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../core/theme.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'user_form_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    // Load data saat pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<UserProvider>(context, listen: false).fetchUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return MainLayout(
      title: 'Manajemen User',
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final User user = userProvider.users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AdminKitTheme.primary,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: user.role == 'admin'
                                ? Colors.green.withAlpha((255 * 0.1).round())
                                : Colors.blue.withAlpha((255 * 0.1).round()),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: user.role == 'admin'
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserFormPage(user: user),
                            ),
                          );
                        } else if (value == 'delete') {
                          _confirmDelete(context, user, userProvider);
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'edit', child: Text("Edit")),
                        if (user.role != 'admin')
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              "Hapus",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminKitTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormPage()),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    User user,
    UserProvider provider,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus User"),
        content: Text("Yakin ingin menghapus ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await provider.deleteUser(user.id);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("User berhasil dihapus")),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
