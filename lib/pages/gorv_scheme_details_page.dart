import 'package:flutter/material.dart';
import 'ai_chat_page.dart';
import 'req_doc_form_fil_page.dart';

class GorvSchemeDetailsPage extends StatefulWidget {
  final Map<String, Object> schemeitem;
  final List<Map<String, Object>> doc;
  final int index;

  const GorvSchemeDetailsPage({
    super.key,
    required this.schemeitem,
    required this.index, 
    required this.doc,
  });

  @override
  State<GorvSchemeDetailsPage> createState() => _GorvSchemeDetailsPageState();
}

class _GorvSchemeDetailsPageState extends State<GorvSchemeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Extract requiredDocuments from the current scheme
   // Map<String, Object> requiredDocuments = widget.doc[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.schemeitem["title"].toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.schemeitem["title"].toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.schemeitem["imageurl"].toString(),
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),
              SizedBox(height: 16),

              // Dates Section (Card for better appearance)
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Starting Date:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.schemeitem["starting-Date"].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Last Date:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.schemeitem["ending-Date"].toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Description Section
              Text(
                "Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                widget.schemeitem["description"].toString(),
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Details Section
              Text(
                "Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                widget.schemeitem["details"].toString(),
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Additional Information Section
              Text(
                "Additional Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.schemeitem["about"].toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),

              // Action Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Pass the requiredDocuments data to the next page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReqDocFormFilPage(docs:widget.schemeitem["doc"] as List<String>, imgurl:widget.schemeitem["imageurl"].toString(), // Pass the documents
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Required Documents",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AiChatPage(
                            title: widget.schemeitem["title"].toString(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "AI Chat",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
