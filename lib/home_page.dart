import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'flutter/upload_item.dart';
import 'user_profile.dart';

class LostItem {
  final String itemName;
  final String description;
  final String location;
  final String contactNumber;
  final String imageData;
  Uint8List? decodedImageData;

  LostItem({
    required this.itemName,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.imageData,
  }) {
    try {
      decodedImageData = base64Decode(imageData);
    } catch (e, stackTrace) {
      print('Error decoding image data: $e');
      decodedImageData = null;
      print('Stack trace: $stackTrace');
      decodedImageData = null;
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LostItem> lostItems = [];

  Future<List<LostItem>> fetchLostItems() async {
    try {
      // Send the request and get the response
      var response =
          await http.get(Uri.parse('http://10.0.2.2/fetch_data.php'));

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

  Widget buildLostItemsList(List<LostItem> lostItems) {
    return ListView.builder(
      itemCount: lostItems.length,
      itemBuilder: (context, index) {
        final item = lostItems[index];
        if (item.decodedImageData == null) {
          // Skip rendering the item if image decoding failed
          return Container();
        }
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(
                item.decodedImageData!,
                width: 200,
                height: 200,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', item.itemName),
                    _buildInfoRow('Location', item.location),
                    _buildInfoRow('Contact', item.contactNumber),
                    _buildInfoRow('Description', item.description),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Fetch the latest data
    List<LostItem> refreshedData = await fetchLostItems();

    // Update the UI
    setState(() {
      // Update the list of lost items with the refreshed data
      lostItems = refreshedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find My Stuff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => navigateToUserProfile(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<LostItem>>(
          future: fetchLostItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to fetch lost items: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final lostItems = snapshot.data!;

              if (lostItems.isEmpty) {
                return const Center(
                  child: Text('No lost items found'),
                );
              }

              return ListView.builder(
                itemCount: lostItems.length,
                itemBuilder: (context, index) {
                  final item = lostItems[index];

                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Image.memory(
                          base64Decode(item.imageData),
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          item.itemName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(item.location),
                        const SizedBox(height: 4.0),
                        Text(item.contactNumber),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No lost items found'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToUploadItem(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void navigateToUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UserProfilePage(username: 'Guest')),
    );
  }

  void navigateToUploadItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadItem()),
    );
  }
}
