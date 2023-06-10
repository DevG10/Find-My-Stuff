import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadItem extends StatefulWidget {
  const UploadItem({Key? key}) : super(key: key);

  @override
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _contactNumberController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _contactNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      try {
        final imageBytes = await _selectedImage!.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        final body = {
          'itemName': _itemNameController.text,
          'description': _descriptionController.text,
          'location': _locationController.text,
          'contactNumber': _contactNumberController.text,
          'imageData': base64Image.replaceAll('.', ''),
        };

        final response = await http.post(
          Uri.parse('http://10.0.2.2/insert_data.php'),
          body: body,
        );

        if (response.statusCode == 200) {
          // Item uploaded successfully
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Item uploaded successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception('Failed to upload item.');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload item: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the item name.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the description.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the location.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the contact number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 16.0),
                _selectedImage != null
                    ? Image.file(_selectedImage!)
                    // : const Placeholder(),
                    : const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _uploadItem,
                  child: const Text('Upload Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
