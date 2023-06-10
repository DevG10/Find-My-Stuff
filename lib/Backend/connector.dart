import 'dart:convert';

import 'package:http/http.dart' as http;

class LostItem {
  final String itemName;
  final String description;
  final String location;
  final String contactNumber;
  final String imageData;

  LostItem({
    required this.itemName,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.imageData,
  });
}

Future<List<LostItem>> fetchLostItems() async {
  try {
    final response =
        await http.get(Uri.parse('http://localhost/fetch_data.php'));
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        // Response is an array
        List<LostItem> lostItems = [];
        for (var item in data) {
          LostItem lostItem = LostItem(
            itemName: item['itemName'] ?? '',
            description: item['description'] ?? '',
            location: item['location'] ?? '',
            contactNumber: item['contactNumber'] ?? '',
            imageData: item['imageData'] ?? '',
          );
          lostItems.add(lostItem);
        }
        return lostItems;
      } else if (data is Map<String, dynamic>) {
        // Response is a single object
        LostItem lostItem = LostItem(
          itemName: data['itemName'] ?? '',
          description: data['description'] ?? '',
          location: data['location'] ?? '',
          contactNumber: data['contactNumber'] ?? '',
          imageData: data['imageData'] ?? '',
        );
        return [lostItem];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch lost items');
    }
  } catch (e) {
    print('An error occurred while fetching lost items: $e');
    throw Exception('Failed to fetch lost items');
  }
}

void main() async {
  try {
    final lostItems = await fetchLostItems();
    for (var item in lostItems) {
      final response =
          await http.get(Uri.parse('http://localhost/fetch_data.php'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Item Name: ${item.itemName}');
      print('Description: ${item.description}');
      print('Location: ${item.location}');
      print('Contact Number: ${item.contactNumber}');
      print('Image Data: ${item.imageData}');
      print('----------------------------');
    }
  } catch (e) {
    print('Error: $e');
  }
}
