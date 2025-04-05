import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResumeAnalyser extends StatefulWidget {
  const ResumeAnalyser({super.key});

  @override
  State<ResumeAnalyser> createState() => _ResumeAnalyserState();
}

class _ResumeAnalyserState extends State<ResumeAnalyser> {
  File? _selectedFile;
  String _fileName = '';
  bool _isLoading = false;
  String _analysisResult = '';
  bool _hasAnalysis = false;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
          _hasAnalysis = false;
          _analysisResult = '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeResume() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a resume file first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would use the following code to make an actual HTTP request
      // to your model API endpoint. For now, we'll just simulate a delay and provide
      // mock response data.

      // Uncomment this code and replace YOUR_API_ENDPOINT when connecting to your model:
      /*
      final request = http.MultipartRequest('POST', Uri.parse('YOUR_API_ENDPOINT'));
      request.files.add(await http.MultipartFile.fromPath('resume', _selectedFile!.path));
      
      // Add any additional fields if needed
      // request.fields['user_id'] = 'user123';
      
      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);
        
        setState(() {
          _isLoading = false;
          _hasAnalysis = true;
          _analysisResult = result['analysis'] ?? 'Analysis completed, but no data returned.';
        });
      } else {
        throw Exception('Failed to analyze resume. Status code: ${response.statusCode}');
      }
      */

      // Mock response for demonstration - Remove this in production
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
        _hasAnalysis = true;
        _analysisResult = '''
Skills Detected:
- Flutter Development (Advanced)
- React.js (Intermediate)
- Node.js (Intermediate)
- Firebase (Advanced)
- REST API Integration (Proficient)
- UI/UX Design (Intermediate)

Recommendations:
1. Add more quantifiable achievements to highlight impact
2. Include links to portfolio projects
3. Organize skills section by proficiency level
4. Add section for soft skills
5. Improve formatting for better ATS compatibility

Match Score: 78% for tech positions
''';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error analyzing resume: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(
          'Resume Analyzer',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with info
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade300,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'How it works',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Upload your resume (PDF, DOC, or DOCX format)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '2. Click "Analyze" to process your resume',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '3. Get detailed feedback and suggestions to improve',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // File upload section
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    _selectedFile != null
                        ? Icons.description
                        : Icons.upload_file,
                    size: 80,
                    color: _selectedFile != null
                        ? Colors.green
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFile != null
                        ? 'Resume Selected'
                        : 'Upload Your Resume',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedFile != null
                        ? _fileName
                        : 'Select a PDF, DOC, or DOCX file',
                    style: TextStyle(
                      color: _selectedFile != null
                          ? Colors.green.shade300
                          : Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_upload),
                    label: Text(
                        _selectedFile != null ? 'Change File' : 'Select File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(200, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedFile != null)
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _analyzeResume,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.analytics),
                      label:
                          Text(_isLoading ? 'Analyzing...' : 'Analyze Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(200, 48),
                      ),
                    ),
                ],
              ),
            ),

            // Analysis results section
            if (_hasAnalysis) ...[
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade900,
                      Colors.indigo.shade900,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.analytics,
                          color: Colors.cyanAccent,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Analysis Results',
                          style: GoogleFonts.orbitron(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _analysisResult,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Share functionality could be implemented here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Share feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () {
                            // Download functionality could be implemented here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Download feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
