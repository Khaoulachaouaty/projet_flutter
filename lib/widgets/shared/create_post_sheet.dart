import 'dart:io';
import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/user.dart';

class CreatePostSheet extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String content, List<File> media, String type) onSubmit;

  const CreatePostSheet({
    super.key,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _contentController = TextEditingController();
  final List<File> _selectedFiles = [];
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() => _selectedFiles.addAll(picked.map((e) => File(e.path))));
    }
  }

  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedFiles.add(File(picked.path)));
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() => _selectedFiles.addAll(
        result.paths.whereType<String>().map((path) => File(path)),
      ));
    }
  }

  void _submit() {
    if (_contentController.text.isEmpty && _selectedFiles.isEmpty) return;
    
    String type = 'text';
    if (_selectedFiles.isNotEmpty) {
      final ext = _selectedFiles.first.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png'].contains(ext)) type = 'image';
      else if (['mp4', 'mov'].contains(ext)) type = 'video';
      else if (ext == 'pdf') type = 'pdf';
    }
    
    widget.onSubmit(_contentController.text, _selectedFiles, type);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTextField(),
              if (_selectedFiles.isNotEmpty) _buildMediaPreview(),
              const SizedBox(height: 16),
              _buildToolbar(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const UserAvatar(name: 'Moi', size: 40),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Créer une publication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose,
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _contentController,
      maxLines: 4,
      decoration: const InputDecoration(
        hintText: 'Qu\'est-ce qui vous passe par la tête ?',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedFiles.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  image: _selectedFiles[index].path.endsWith('.pdf')
                      ? null
                      : DecorationImage(
                          image: FileImage(_selectedFiles[index]),
                          fit: BoxFit.cover,
                        ),
                ),
                child: _selectedFiles[index].path.endsWith('.pdf')
                    ? const Icon(Icons.picture_as_pdf, color: AppColors.error)
                    : null,
              ),
              Positioned(
                top: 4,
                right: 12,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFiles.removeAt(index)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        _ToolbarButton(
          icon: Icons.image,
          color: AppColors.success,
          onTap: _pickImage,
        ),
        _ToolbarButton(
          icon: Icons.videocam,
          color: AppColors.primary,
          onTap: _pickVideo,
        ),
        _ToolbarButton(
          icon: Icons.picture_as_pdf,
          color: AppColors.error,
          onTap: _pickPdf,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : const Text('Publier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color),
          ),
        ),
      ),
    );
  }
}