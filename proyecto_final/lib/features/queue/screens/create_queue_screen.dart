import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/queue_service.dart';

class CreateQueueScreen extends StatefulWidget {
  const CreateQueueScreen({super.key});

  @override
  State<CreateQueueScreen> createState() => _CreateQueueScreenState();
}

class _CreateQueueScreenState extends State<CreateQueueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController(text: '20');
  final TextEditingController _timerController = TextEditingController(text: '60');
  final TextEditingController _urlController = TextEditingController();
  bool _enableNotifications = false;
  bool _enableMaxPeopleLimit = false;
  bool _isLoading = false;

  final Map<String, String> _infoMessages = {
    'Maximum people:': 'Maximum number of users allowed simultaneously in the queue.',
    'Timer (seconds):': 'This sets how long each user stays at the front of the queue before being automatically moved.',
    'File URL': 'Paste a URL to a menu, website, PDF, or any online resource you want users to see while waiting in the queue.\n\nExamples:\n• Restaurant menu (PDF)\n• Website with instructions\n• Image with information\n\nThis field is optional.',
    'Notifications': 'Enable alerts so you receive updates when someone joins or reaches the front of the queue.',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxPeopleController.dispose();
    _timerController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return true; // URL is optional
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          drawer: const AppDrawer(),
          body: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context, themeProvider),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildTextField(
                              themeProvider,
                              'Add a Title for your line*:',
                              _titleController,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              themeProvider,
                              'Description*:',
                              _descriptionController,
                            ),
                            const SizedBox(height: 20),
                            _buildMaxPeopleSection(themeProvider),
                            const SizedBox(height: 20),
                            _buildNumberField(
                              themeProvider,
                              'Timer (seconds):',
                              _timerController,
                            ),
                            const SizedBox(height: 20),
                            _buildUrlSection(themeProvider),
                            const SizedBox(height: 20),
                            _buildNotificationToggle(themeProvider),
                            const SizedBox(height: 30),
                            _buildDoneButton(context, themeProvider),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: themeProvider.secondaryColor,
            ),
            child: Text(
              "CREATE A QUEUE",
              textAlign: TextAlign.center,
              style: GoogleFonts.ericaOne(
                color: themeProvider.backgroundColor,
                fontSize: 36,
                height: 1.0,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: themeProvider.backgroundColor,
                  size: 30,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    ThemeProvider themeProvider,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.lexendDeca(
              color: Colors.black,
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField(
    ThemeProvider themeProvider,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _showInfoDialog(label);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: themeProvider.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: themeProvider.textPrimary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              _buildArrowButton(
                themeProvider,
                Icons.arrow_drop_down,
                () {
                  int currentValue = int.tryParse(controller.text) ?? 0;
                  if (currentValue > 0) {
                    controller.text = (currentValue - 1).toString();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              _buildArrowButton(
                themeProvider,
                Icons.arrow_drop_up,
                () {
                  int currentValue = int.tryParse(controller.text) ?? 0;
                  controller.text = (currentValue + 1).toString();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(
    ThemeProvider themeProvider,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: themeProvider.textPrimary,
        iconSize: 32,
        onPressed: onPressed,
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  Widget _buildMaxPeopleSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: themeProvider.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: _enableMaxPeopleLimit
                      ? themeProvider.secondaryColor
                      : themeProvider.textPrimary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: themeProvider.secondaryColor,
                    width: 2,
                  ),
                ),
                child: Switch(
                  value: _enableMaxPeopleLimit,
                  onChanged: (value) {
                    setState(() {
                      _enableMaxPeopleLimit = value;
                    });
                  },
                  activeColor: themeProvider.textPrimary,
                  activeTrackColor: themeProvider.secondaryColor,
                  inactiveThumbColor: themeProvider.secondaryColor,
                  inactiveTrackColor: themeProvider.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Maximum people limit',
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInfoDialog('Maximum people:');
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: themeProvider.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: themeProvider.textPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_enableMaxPeopleLimit) ...[
          const SizedBox(height: 12),
          _buildNumberField(
            themeProvider,
            'Maximum people:',
            _maxPeopleController,
          ),
        ],
      ],
    );
  }

  Widget _buildUrlSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Resource URL (Optional)',
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _showInfoDialog('File URL');
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: themeProvider.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: themeProvider.textPrimary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: TextField(
            controller: _urlController,
            style: GoogleFonts.lexendDeca(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'https://example.com/menu.pdf',
              hintStyle: GoogleFonts.lexendDeca(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.link,
                color: themeProvider.secondaryColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.url,
          ),
        ),
        if (_urlController.text.isNotEmpty && !_isValidUrl(_urlController.text))
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Please enter a valid URL (must start with http:// or https://)',
                  style: GoogleFonts.lexendDeca(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationToggle(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: _enableNotifications
                  ? themeProvider.secondaryColor
                  : themeProvider.textPrimary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: themeProvider.secondaryColor,
                width: 2,
              ),
            ),
            child: Switch(
              value: _enableNotifications,
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                });
              },
              activeColor: themeProvider.textPrimary,
              activeTrackColor: themeProvider.secondaryColor,
              inactiveThumbColor: themeProvider.secondaryColor,
              inactiveTrackColor: themeProvider.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Enable Notifications',
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showInfoDialog('Notifications');
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: themeProvider.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline,
                color: themeProvider.textPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 0,
        ),
        onPressed: () => _handleCreateQueue(context, themeProvider),
        child: Text(
          'DONE',
          style: GoogleFonts.ericaOne(
            color: themeProvider.backgroundColor,
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateQueue(BuildContext context, ThemeProvider themeProvider) async {
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a title');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return;
    }

    int? maxPeople;
    if (_enableMaxPeopleLimit) {
      maxPeople = int.tryParse(_maxPeopleController.text);
      if (maxPeople == null || maxPeople <= 0) {
        _showErrorSnackBar('Maximum people must be greater than 0');
        return;
      }
    }

    final timerSeconds = int.tryParse(_timerController.text) ?? 60;
    if (timerSeconds <= 0) {
      _showErrorSnackBar('Timer must be greater than 0');
      return;
    }

    final url = _urlController.text.trim();
    if (url.isNotEmpty && !_isValidUrl(url)) {
      _showErrorSnackBar('Please enter a valid URL or leave it empty');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final queueService = QueueService();

      final userId = authService.currentUser?.uid;
      if (userId == null) {
        throw 'User not authenticated';
      }

      final queueId = await queueService.createQueue(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        maxPeople: maxPeople,
        timerSeconds: timerSeconds,
        enableNotifications: _enableNotifications,
        creatorId: userId,
        fileUrl: url.isNotEmpty ? url : null,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog(context, themeProvider, queueId);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(e.toString());
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoDialog(String key) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final info = _infoMessages[key] ?? 'No information available';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          title: Text(
            key,
            style: GoogleFonts.ericaOne(
              color: themeProvider.secondaryColor,
              fontSize: 22,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              info,
              style: GoogleFonts.lexendDeca(
                color: themeProvider.backgroundColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'GOT IT',
                style: GoogleFonts.ericaOne(
                  color: themeProvider.secondaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, ThemeProvider themeProvider, String queueId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeProvider.textField,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.secondaryColor,
                width: 10,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: themeProvider.secondaryColor,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  'QUEUE CREATED!',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your queue has been created successfully',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.secondaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                      context,
                      '/queue-qr',
                      arguments: queueId,
                    );
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}