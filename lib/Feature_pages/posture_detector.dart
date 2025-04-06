import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Posturedetector extends StatefulWidget {
  const Posturedetector({Key? key}) : super(key: key);

  @override
  State<Posturedetector> createState() => _PosturedetectorState();
}

class _PosturedetectorState extends State<Posturedetector> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _postureResult = '';
  String _errorMessage = '';

  // Store parsed response data
  String _headPosition = '';
  int _postureScore = 0;
  String _shoulderAlignment = '';
  int _timestamp = 0;

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _postureResult = '';
          _errorMessage = '';
          // Reset analysis results
          _headPosition = '';
          _postureScore = 0;
          _shoulderAlignment = '';
          _timestamp = 0;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  // Upload image and detect posture
  Future<void> _detectPosture() async {
    if (_image == null) {
      setState(() {
        _errorMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _postureResult = '';
    });

    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.154.163:5000/analyze'),
      );

      // Add image file to request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
      ));

      // Add debugging
      print('Sending image: ${_image!.path}');

      // Optional: Add any required headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response
        final jsonResponse = jsonDecode(response.body);

        // Parse the structured response
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          setState(() {
            _headPosition = data['head_position'] ?? 'Unknown';
            _postureScore = data['posture_score'] ?? 0;
            _shoulderAlignment = data['shoulder_alignment'] ?? 'Unknown';
            _timestamp = data['timestamp'] ?? 0;
            _postureResult =
                'Analysis complete'; // Just a marker that we have results
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Invalid response format: ${response.body}';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Server error ${response.statusCode}: ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exception during request: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error detecting posture: $e';
      });
    }
  }

  // Mock detection for testing when API is not available
  Future<void> _mockDetectPosture() async {
    if (_image == null) {
      setState(() {
        _errorMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _postureResult = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock results - in a real app, this would come from the API
    final List<String> possibleResults = [
      'Good posture. Your alignment is excellent!',
      'Slight forward head posture detected. Try to align your ears with your shoulders.',
      'Slouching detected. Try to engage your core and straighten your back.',
      'Rounded shoulders detected. Consider exercises to strengthen upper back muscles.',
      'Anterior pelvic tilt detected. Focus on core and glute strengthening exercises.'
    ];

    // Randomly select a result for demo purposes
    final result = possibleResults[
        DateTime.now().millisecondsSinceEpoch % possibleResults.length];

    setState(() {
      _postureResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text(
          'Posture Detection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0E21),
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image display area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _image == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No image selected',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.grey[900],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                            title: const Text(
                                              'Take a photo',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.camera);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                              color: Colors.white,
                                            ),
                                            title: const Text(
                                              'Choose from gallery',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.gallery);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                      _postureResult = '';
                                      _errorMessage = '';
                                      // Reset analysis results
                                      _headPosition = '';
                                      _postureScore = 0;
                                      _shoulderAlignment = '';
                                      _timestamp = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Result display
              if (_postureResult.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Posture Analysis',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.face,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Head Position: $_headPosition',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.score,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Posture Score: $_postureScore/100',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _postureScore / 100,
                                      minHeight: 8,
                                      color: _getScoreColor(_postureScore),
                                      backgroundColor: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.accessibility_new,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Shoulder Alignment: $_shoulderAlignment',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Detect button
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                child: ElevatedButton(
                  onPressed: _isLoading || _image == null
                      ? null
                      : _detectPosture, // Use real API call instead of mock
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.blue.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Analyzing...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Detect Posture',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.amber;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}
