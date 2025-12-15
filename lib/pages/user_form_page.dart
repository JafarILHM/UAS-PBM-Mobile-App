import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../core/theme.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class UserFormPage extends StatefulWidget {
  final User? user; // Jika null = Mode Tambah, Jika ada = Mode Edit
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  
  String _selectedRole = 'staff';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    if (widget.user != null) {
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final provider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      bool success;
      if (widget.user == null) {
        // Mode Tambah
        success = await provider.addUser(
          _nameController.text,
          _emailController.text,
          _passwordController.text, // Password wajib saat create
          _selectedRole,
        );
      } else {
        // Mode Edit
        success = await provider.updateUser(
          widget.user!.id,
          _nameController.text,
          _emailController.text,
          _passwordController.text.isEmpty ? null : _passwordController.text, // Password opsional
          _selectedRole,
        );
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: ${e.toString().replaceAll('Exception:', '')}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return MainLayout(
      title: isEdit ? "Edit User" : "Tambah User",
      body: SingleChildScrollView(
        child: AdminCard(
          title: "Form User",
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama Lengkap", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Nama User"),
                  validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "email@example.com"),
                  validator: (val) => val!.isEmpty || !val.contains('@') ? "Email tidak valid" : null,
                ),
                const SizedBox(height: 16),

                Text(isEdit ? "Password (Kosongkan jika tidak diganti)" : "Password", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "******"),
                  validator: (val) {
                    if (!isEdit && (val == null || val.length < 6)) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text("Role / Jabatan", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'staff', child: Text("Staff Gudang")),
                    DropdownMenuItem(value: 'admin', child: Text("Admin (Kepala)")),
                  ],
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminKitTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Simpan Data", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}