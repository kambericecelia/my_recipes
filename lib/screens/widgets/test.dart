// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImagePickerHelper {
//   static Future<File?> showImagePickerDialog(BuildContext context) async {
//     return showModalBottomSheet<File>(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Photo Library'),
//                 onTap: () async {
//                   Navigator.of(context).pop(
//                       await _pickImage(ImageSource.gallery)
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Camera'),
//                 onTap: () async {
//                   Navigator.of(context).pop(
//                       await _pickImage(ImageSource.camera)
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   static Future<File?> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: source,
//       // Optional parameters you might want to add
//       maxWidth: 800,
//       maxHeight: 600,
//       imageQuality: 80, // Compress the image
//     );
//
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//     return null;
//   }
// }
//
// // In your AddRecipe widget, modify the image picking button:
// class AddRecipe extends StatefulWidget {
//   // ... existing code ...
//
//   @override
//   State<AddRecipe> createState() => _AddRecipeState();
// }
//
// class _AddRecipeState extends State<AddRecipe> {
//   // ... other existing properties ...
//
//   Future<void> _pickImage() async {
//     final selectedImage = await ImagePickerHelper.showImagePickerDialog(context);
//
//     if (selectedImage != null) {
//       setState(() {
//         _selectedImage = selectedImage;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ... other existing code ...
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // ... other widgets ...
//
//               // Replace your existing "Add image" button with this:
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
//                 child: ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: Icon(Icons.add_a_photo),
//                   label: Text("Add Image"),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size.fromHeight(45),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Image preview
//               if (_selectedImage != null)
//                 Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       Image.file(
//                         _selectedImage!,
//                         width: double.infinity,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.remove_circle, color: Colors.red),
//                         onPressed: () {
//                           setState(() {
//                             _selectedImage = null;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//
//               // ... rest of your existing code ...
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }