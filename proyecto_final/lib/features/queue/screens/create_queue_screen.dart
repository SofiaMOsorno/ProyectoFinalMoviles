import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';

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
  bool _enableNotifications = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxPeopleController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          drawer: const AppDrawer(),
          body: Column(
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
                        _buildNumberField(
                          themeProvider,
                          'Maximum people:',
                          _maxPeopleController,
                        ),
                        const SizedBox(height: 20),
                        _buildNumberField(
                          themeProvider,
                          'Timer (seconds):',
                          _timerController,
                        ),
                        const SizedBox(height: 20),
                        _buildUploadSection(themeProvider),
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
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: themeProvider.textPrimary,
                size: 30,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Expanded(
            child: Container(
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
          ),
          const SizedBox(width: 48),
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

  Widget _buildUploadSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Would you like\nyour queue to\nvisualize a file?',
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _showInfoDialog('File visualization');
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
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker coming soon'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeProvider.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.upload_file,
                    color: themeProvider.textPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Upload File',
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
        onPressed: () {
          _showSuccessDialog(context, themeProvider);
        },
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

  void _showInfoDialog(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
            title,
            style: GoogleFonts.ericaOne(
              color: themeProvider.secondaryColor,
              fontSize: 24,
            ),
          ),
          content: Text(
            'This is placeholder information about $title',
            style: GoogleFonts.lexendDeca(
              color: themeProvider.backgroundColor,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
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

  void _showSuccessDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
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
                    fontSize: 32,
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
                    Navigator.pop(context);
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