import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';

class ManagementScreen extends StatefulWidget {
  final String queueName;

  const ManagementScreen({
    super.key,
    required this.queueName,
  });

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  bool _showUsernames = false;

  final List<Map<String, String>> _queueMembers = [
    {'name': 'Hermenegildo'},
    {'name': 'Batraclo'},
    {'name': 'Gerbacio'},
    {'name': 'Herculano'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: Column(
            children: [
              _buildHeader(context, themeProvider),
              Expanded(
                child: Column(
                  children: [
                    _buildQueueInfo(themeProvider),
                    Expanded(
                      child: _buildQueueList(themeProvider),
                    ),
                    _buildBottomControls(context, themeProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
      ),
      child: Text(
        "MANAGEMENT",
        textAlign: TextAlign.center,
        style: GoogleFonts.ericaOne(
          color: themeProvider.backgroundColor,
          fontSize: 36,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildQueueInfo(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: themeProvider.backgroundColor,
      child: Text(
        'People in your queue (${_queueMembers.length}/3)',
        style: GoogleFonts.lexendDeca(
          color: themeProvider.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQueueList(ThemeProvider themeProvider) {
    return Container(
      color: themeProvider.backgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _queueMembers.length,
        itemBuilder: (context, index) {
          return _buildQueueMemberItem(
            themeProvider,
            _queueMembers[index]['name']!,
          );
        },
      ),
    );
  }

  Widget _buildQueueMemberItem(ThemeProvider themeProvider, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.textPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.grid_view,
              color: themeProvider.secondaryColor,
              size: 24,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: themeProvider.textPrimary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Text(
                name,
                style: GoogleFonts.lexendDeca(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.textPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                _showRemoveUserDialog(name, themeProvider);
              },
              child: Icon(
                Icons.close,
                color: themeProvider.secondaryColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: themeProvider.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAllowMoreUsersButton(themeProvider),
          const SizedBox(height: 12),
          _buildSeeQRButton(themeProvider),
          const SizedBox(height: 12),
          _buildShowUsernamesToggle(themeProvider),
          const SizedBox(height: 12),
          _buildBackButton(context, themeProvider),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAllowMoreUsersButton(ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Allow more users functionality coming soon'),
            ),
          );
        },
        child: Text(
          'Allow more users to join',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSeeQRButton(ThemeProvider themeProvider) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code functionality coming soon'),
          ),
        );
      },
      child: Text(
        'See QR',
        style: GoogleFonts.lexendDeca(
          color: themeProvider.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: themeProvider.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildShowUsernamesToggle(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 28,
          decoration: BoxDecoration(
            color: _showUsernames
                ? themeProvider.secondaryColor
                : themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 2,
            ),
          ),
          child: Switch(
            value: _showUsernames,
            onChanged: (value) {
              setState(() {
                _showUsernames = value;
              });
            },
            activeColor: themeProvider.textPrimary,
            activeTrackColor: themeProvider.secondaryColor,
            inactiveThumbColor: themeProvider.secondaryColor,
            inactiveTrackColor: themeProvider.textPrimary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Show usernames',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
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
      ],
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'BACK',
          style: GoogleFonts.ericaOne(
            color: themeProvider.backgroundColor,
            fontSize: 40,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  void _showRemoveUserDialog(String userName, ThemeProvider themeProvider) {
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
                Text(
                  'REMOVE USER?',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to remove "$userName" from the queue?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 18,
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
                    setState(() {
                      _queueMembers.removeWhere((member) => member['name'] == userName);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$userName removed from queue'),
                        backgroundColor: themeProvider.backgroundColor,
                      ),
                    );
                  },
                  child: Text(
                    'REMOVE',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.backgroundColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
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