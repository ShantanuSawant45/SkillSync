import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ResumeAnalyser extends StatefulWidget {
  const ResumeAnalyser({super.key});

  @override
  State<ResumeAnalyser> createState() => _ResumeAnalyserState();
}

class _ResumeAnalyserState extends State<ResumeAnalyser>
    with SingleTickerProviderStateMixin {
  File? _selectedFile;
  String _fileName = '';
  bool _isLoading = false;
  bool _hasAnalysis = false;

  // New variables for structured response
  double _overallScore = 0.0;
  List<String> _issues = [];
  List<String> _recommendations = [];
  Map<String, dynamic> _skillsAnalysis = {};
  Map<String, dynamic> _atsAnalysis = {};
  Map<String, dynamic> _experienceAnalysis = {};
  Map<String, dynamic> _formattingAnalysis = {};
  String _analysisDate = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          // Reset analy  sis data when new file is selected
          _overallScore = 0.0;
          _issues = [];
          _recommendations = [];
          _skillsAnalysis = {};
          _atsAnalysis = {};
          _experienceAnalysis = {};
          _formattingAnalysis = {};
          _analysisDate = '';
        });
        _animationController.reset();
        _animationController.forward();
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
      // Reset all analysis variables
      _overallScore = 0.0;
      _issues = [];
      _recommendations = [];
      _skillsAnalysis = {};
      _atsAnalysis = {};
      _experienceAnalysis = {};
      _formattingAnalysis = {};
      _analysisDate = '';
      _hasAnalysis = false;
    });

    try {
      const String baseUrl = "http://192.168.154.14:5000/analyze";
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers['connection-timeout'] = '15000';
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
        filename: _fileName,
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connecting to server...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
              "Connection to server timed out. Please check your network and server status.");
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        if (result['status'] == 'success') {
          final data = result['data'];

          setState(() {
            _isLoading = false;
            _hasAnalysis = true;
            _analysisDate = result['analysis_date'] ?? '';

            // Destructure the response into separate variables
            _overallScore = (data['overall_score'] as num?)?.toDouble() ?? 0.0;

            // Extract recommendations
            if (data['recommendations'] is List) {
              _recommendations = List<String>.from(data['recommendations'] ?? []);
            }

            // Extract skills analysis
            if (data['skills_analysis'] is Map) {
              _skillsAnalysis = Map<String, dynamic>.from(data['skills_analysis'] ?? {});
            }

            // Extract ATS analysis
            if (data['ats_analysis'] is Map) {
              _atsAnalysis = Map<String, dynamic>.from(data['ats_analysis'] ?? {});
              // Combine ATS issues and warnings into our issues list
              _issues = [
                ...(_atsAnalysis['issues'] as List<dynamic>? ?? []).cast<String>(),
                ...(_atsAnalysis['warnings'] as List<dynamic>? ?? []).cast<String>(),
              ];
            }

            // Extract experience analysis
            if (data['experience_analysis'] is Map) {
              _experienceAnalysis = Map<String, dynamic>.from(data['experience_analysis'] ?? {});
              // Add experience issues to our main issues list
              _issues.addAll(
                (_experienceAnalysis['issues'] as List<dynamic>? ?? []).cast<String>(),
              );
            }

            // Extract formatting analysis
            if (data['formatting_analysis'] is Map) {
              _formattingAnalysis = Map<String, dynamic>.from(data['formatting_analysis'] ?? {});
              // Add formatting issues to our main issues list
              _issues.addAll(
                (_formattingAnalysis['issues'] as List<dynamic>? ?? []).cast<String>(),
              );
            }
          });

          _animationController.reset();
          _animationController.forward();
        } else {
          throw Exception(result['error'] ?? 'Failed to analyze resume');
        }
      } else {
        throw Exception(
            'Failed to analyze resume. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show a more user-friendly error message for common issues
      String errorMessage = e.toString();

      if (errorMessage.contains('SocketException') ||
          errorMessage.contains('timed out')) {
        errorMessage = 'Unable to connect to the server. Please check:\n'
            '1. The server is running\n'
            '2. Both devices are on the same network\n'
            '3. The server IP address is correct\n'
            '4. No firewall is blocking the connection';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Futuristic Header
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900.withOpacity(0.7),
                    Colors.indigo.shade900.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics_outlined,
                          color: Colors.cyanAccent,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI-Powered Resume Analysis',
                              style: GoogleFonts.orbitron(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Get professional feedback on your resume instantly',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Steps with horizontal layout
                  Row(
                    children: [
                      _buildStepIndicator('1', 'Upload'),
                      _buildStepLine(),
                      _buildStepIndicator('2', 'Analyze'),
                      _buildStepLine(),
                      _buildStepIndicator('3', 'Review'),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

                  // File Upload Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1A2151),
                          const Color(0xFF192547),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: GridPainter(
                                color: Colors.blue.withOpacity(0.1),
                                lineWidth: 1,
                                spacing: 20,
                              ),
                            ),
                          ),

                          // Glowing accents
                          Positioned(
                            top: -50,
                            right: -50,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // File upload area
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: _selectedFile != null ? 180 : 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: _selectedFile != null
                                          ? Colors.green.withOpacity(0.5)
                                          : Colors.blue.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _selectedFile != null
                                      ? _buildSelectedFilePreview()
                                      : _buildFileUploadArea(),
                                ),

                                const SizedBox(height: 30),

                                // Action buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_selectedFile == null)
                                      _buildActionButton(
                                        'Select Resume',
                                        Icons.upload_file,
                                        Colors.blueAccent,
                                        _pickFile,
                                        width: screenSize.width * 0.7,
                                      )
                                    else
                                      Row(
                                        children: [
                                          _buildActionButton(
                                            'Change',
                                            Icons.file_upload,
                                            Colors.blueAccent,
                                            _pickFile,
                                            width: screenSize.width * 0.3,
                                          ),
                                          const SizedBox(width: 8),
                                          _buildActionButton(
                                            _isLoading
                                                ? 'Analyzing...'
                                                : 'Analyze',
                                            _isLoading
                                                ? Icons.hourglass_top
                                                : Icons.analytics,
                                            Colors.greenAccent,
                                            _isLoading ? null : _analyzeResume,
                                            isLoading: _isLoading,
                                            width: screenSize.width * 0.4,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Analysis results section
                  if (_hasAnalysis) ...[
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildResultsCard(),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Additional info card
                  _buildInfoCard(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 1.5),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 30,
      height: 1.5,
      color: Colors.white24,
    );
  }

  Widget _buildFileUploadArea() {
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload_file,
              color: Colors.cyanAccent,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Drag & drop your resume here',
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'or click to browse files (PDF, DOC, DOCX)',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFilePreview() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Document lines decoration
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      5,
                          (index) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 4,
                        width: index.isEven ? 60 : 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),

                // Document icon overlay
                Positioned(
                  top: 5,
                  left: 10,
                  child: Text(
                    _getFileExtension(_fileName).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Corner fold
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.5),
                          Colors.cyanAccent.withOpacity(0.5),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Resume Selected',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ready for analysis',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last;
  }

  Widget _buildActionButton(
      String label,
      IconData iconData,
      Color color,
      VoidCallback? onPressed, {
        bool isLoading = false,
        double width = 200,
      }) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Icon(iconData),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: color.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
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
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.cyanAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Analysis Results',
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Score indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overall score',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_overallScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: _getScoreColor(_overallScore),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 8),

                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Analysis date
          if (_analysisDate.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Analyzed on: ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Skills section
          if (_skillsAnalysis.isNotEmpty) ...[
            _buildAnalysisSection(
              'Skills Analysis',
              Icons.code,
              [
                if (_skillsAnalysis['programming'] is List && (_skillsAnalysis['programming'] as List).isNotEmpty)
                  _buildSkillsList('Programming', _skillsAnalysis['programming']),
                if (_skillsAnalysis['soft_skills'] is List && (_skillsAnalysis['soft_skills'] as List).isNotEmpty)
                  _buildSkillsList('Soft Skills', _skillsAnalysis['soft_skills']),
                if (_skillsAnalysis['tools'] is List && (_skillsAnalysis['tools'] as List).isNotEmpty)
                  _buildSkillsList('Tools', _skillsAnalysis['tools']),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Issues section
          if (_issues.isNotEmpty) ...[
            _buildAnalysisSection(
              'Key Issues',
              Icons.warning_amber_rounded,
              _issues.map((issue) => _buildBulletPoint(issue)).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // ATS Analysis section
          if (_atsAnalysis.isNotEmpty) ...[
            _buildAnalysisSection(
              'ATS Analysis',
              Icons.auto_awesome_mosaic,
              [
                if (_atsAnalysis['score'] != null)
                  _buildScoreIndicator('ATS Score', _atsAnalysis['score']),
                if (_atsAnalysis['issues'] is List && (_atsAnalysis['issues'] as List).isNotEmpty)
                  ..._buildSubsection('Critical Issues', _atsAnalysis['issues']),
                if (_atsAnalysis['warnings'] is List && (_atsAnalysis['warnings'] as List).isNotEmpty)
                  ..._buildSubsection('Warnings', _atsAnalysis['warnings']),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Recommendations section
          if (_recommendations.isNotEmpty) ...[
            _buildAnalysisSection(
              'Recommendations',
              Icons.lightbulb_outline,
              _recommendations.map((rec) => _buildBulletPoint(rec)).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.cyanAccent,
                  side: const BorderSide(color: Colors.cyanAccent, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download feature coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download Report',
                    style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.cyanAccent,
                  side: const BorderSide(color: Colors.cyanAccent, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.greenAccent;
    if (score >= 60) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  // String _formatAnalysisDate(String dateString) {
  //   try {
  //     final dateTime = DateTime.parse(dateString);
  //     return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  //   } catch (e) {
  //     return dateString;
  //   }
  // }

  Widget _buildAnalysisSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.cyanAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSkillsList(String category, List<dynamic> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$category:',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: skills.map((skill) => Chip(
            label: Text(
              skill.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.blue.shade900,
            labelStyle: const TextStyle(color: Colors.white),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.cyanAccent),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(String label, dynamic score) {
    final scoreValue = (score is num) ? score.toDouble() : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            '${scoreValue.toStringAsFixed(1)}%',
            style: TextStyle(
              color: _getScoreColor(scoreValue),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubsection(String title, List<dynamic> items) {
    return [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      ...items.map((item) => _buildBulletPoint(item.toString())).toList(),
      const SizedBox(height: 12),
    ];
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Why Use Resume Analyzer?',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _InfoPoint(
            icon: Icons.event_available,
            title: 'ATS Compatibility',
            description: 'Ensure your resume passes Applicant Tracking Systems',
          ),
          const SizedBox(height: 12),
          const _InfoPoint(
            icon: Icons.analytics_outlined,
            title: 'Skill Evaluation',
            description: 'Get feedback on your skills presentation & format',
          ),
          const SizedBox(height: 12),
          const _InfoPoint(
            icon: Icons.trending_up,
            title: 'Improvement Tips',
            description:
            'Receive actionable suggestions to enhance your resume',
          ),
        ],
      ),
    );
  }
}

class _InfoPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoPoint({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade300,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  GridPainter({
    required this.color,
    required this.lineWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}