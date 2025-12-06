import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/buku_model.dart';
import '../../repositories/buku_repository.dart';
import 'package:intl/intl.dart';

class BookFormScreen extends StatefulWidget {
  final Buku? book; // Null for add mode, contains data for edit mode
  final VoidCallback? onBookAdded; // Callback when book is added

  const BookFormScreen({super.key, this.book, this.onBookAdded});

  @override
  State<BookFormScreen> createState() => BookFormScreenState();
}

class BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final BukuRepository _bukuRepository = BukuRepository();

  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _volumeController = TextEditingController();
  final _tanggalMasukController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditMode => widget.book != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Populate form with existing book data
      _judulController.text = widget.book!.judul;
      _penulisController.text = widget.book!.penulis;
      _penerbitController.text = widget.book!.penerbit;
      _hargaController.text = widget.book!.harga.toString();
      _jumlahController.text = widget.book!.jumlah.toString();
      _volumeController.text = widget.book!.volume.toString();
      _tanggalMasukController.text = widget.book!.tanggalMasuk;
    } else {
      // Set default date to today for add mode
      _tanggalMasukController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _volumeController.dispose();
    _tanggalMasukController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: const Color(0xFFCFAB8D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalMasukController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final buku = Buku(
        id: _isEditMode ? widget.book!.id : null,
        judul: _judulController.text.trim(),
        penulis: _penulisController.text.trim(),
        penerbit: _penerbitController.text.trim(),
        harga: int.parse(_hargaController.text.trim()),
        jumlah: int.parse(_jumlahController.text.trim()),
        volume: int.parse(_volumeController.text.trim()),
        tanggalMasuk: _tanggalMasukController.text.trim(),
      );

      if (_isEditMode) {
        // Update existing book
        await _bukuRepository.updateBuku(widget.book!.id!, buku);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil diperbarui'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } else {
        // Add new book
        await _bukuRepository.insertBuku(buku);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil ditambahkan'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Notify parent and trigger callback
          widget.onBookAdded?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Gagal memperbarui buku: $e'
                  : 'Gagal menambahkan buku: $e',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Buku' : 'Tambah Buku'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 0,
                color: const Color(0xFFCFAB8D).withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCFAB8D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.book_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _isEditMode
                              ? 'Edit informasi buku di bawah ini'
                              : 'Isi formulir di bawah untuk menambahkan buku baru',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Form Fields
              _buildTextField(
                controller: _judulController,
                label: 'Judul Buku',
                icon: Icons.title,
                hint: 'Masukkan judul buku',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul buku tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _penulisController,
                label: 'Penulis',
                icon: Icons.person,
                hint: 'Masukkan nama penulis',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penulis tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _penerbitController,
                label: 'Penerbit',
                icon: Icons.business,
                hint: 'Masukkan nama penerbit',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penerbit tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _hargaController,
                label: 'Harga',
                icon: Icons.attach_money,
                hint: 'Masukkan harga buku',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Harga harus lebih dari 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _jumlahController,
                label: 'Jumlah',
                icon: Icons.inventory,
                hint: 'Masukkan jumlah buku',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah harus berupa angka';
                  }
                  if (int.parse(value) < 0) {
                    return 'Jumlah tidak boleh negatif';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _volumeController,
                label: 'Volume',
                icon: Icons.book_outlined,
                hint: 'Masukkan volume',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Volume tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Volume harus berupa angka';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Volume harus lebih dari 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tanggalMasukController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Masuk',
                  hintText: 'Pilih tanggal',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _selectDate,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal masuk tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCFAB8D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isEditMode ? Icons.save : Icons.add),
                            const SizedBox(width: 8),
                            Text(
                              _isEditMode ? 'Perbarui Buku' : 'Simpan Buku',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              if (!_isEditMode) ...[
                const SizedBox(height: 16),

                // Reset Button (only in add mode)
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                            _judulController.clear();
                            _penulisController.clear();
                            _penerbitController.clear();
                            _hargaController.clear();
                            _jumlahController.clear();
                            _volumeController.clear();
                            _tanggalMasukController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(DateTime.now());
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text(
                          'Reset Form',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
