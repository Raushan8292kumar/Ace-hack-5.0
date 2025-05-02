import 'package:flutter/material.dart';

class ReqDocFormFilPage extends StatefulWidget {
  final List<String> docs;
  final String imgurl;
  const ReqDocFormFilPage({super.key, required this.docs, required this.imgurl});

  @override
  State<ReqDocFormFilPage> createState() => _ReqDocFormFilPageState();
}

class _ReqDocFormFilPageState extends State<ReqDocFormFilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Required Documents"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.docs.length,
        itemBuilder: (context, index) {
          final item = widget.docs[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.imgurl),
                radius: 28,
              ),
              title: Text(
                "${index + 1}. $item",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Tap to view or upload document"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () {
                // Handle navigation or file upload
              },
            ),
          );
        },
      ),
    );
  }
}
