import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';

class CreatedQueuesScreen extends StatelessWidget {
  const CreatedQueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryColor,
          drawer: const AppDrawer(),
          body: Column(
            children: [
              _buildHeader(context, themeProvider),
              _buildQueuesList(context, themeProvider),
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
                "CREATED QUEUE",
                textAlign: TextAlign.center,
                style: GoogleFonts.ericaOne(
                  color: themeProvider.primaryColor,
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

  Widget _buildQueuesList(BuildContext context, ThemeProvider themeProvider) {
    final List<Map<String, String>> queues = [
      {'name': 'FAMILY'},
      {'name': 'COSTCO'},
      {'name': 'PARTY'},
      {'name': 'RESTAURANT'},
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  Text(
                    'Your Queues',
                    style: GoogleFonts.lexendDeca(
                      color: themeProvider.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeProvider.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'i',
                      style: GoogleFonts.ericaOne(
                        color: themeProvider.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: queues.length,
                itemBuilder: (context, index) {
                  return _buildQueueItem(
                    context,
                    themeProvider,
                    queues[index]['name']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildCreateQueueButton(context, themeProvider),
            const SizedBox(height: 20),
            _buildBackButton(context, themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(BuildContext context, ThemeProvider themeProvider, String queueName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              queueName,
              style: GoogleFonts.ericaOne(
                color: themeProvider.textPrimary,
                fontSize: 24,
              ),
            ),
          ),
          _buildActionButton(
            context,
            themeProvider,
            Icons.edit,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edit $queueName'),
                  backgroundColor: themeProvider.backgroundColor,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            context,
            themeProvider,
            Icons.delete,
            () {
              _showDeleteConfirmationDialog(context, themeProvider, queueName);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeProvider themeProvider,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.textPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeProvider.primaryColor,
          width: 2,
        ),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: themeProvider.secondaryColor,
        iconSize: 24,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildCreateQueueButton(BuildContext context, ThemeProvider themeProvider) {
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
          Navigator.pushNamed(context, '/create-queue');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: themeProvider.textPrimary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'CREATE QUEUE',
              style: GoogleFonts.ericaOne(
                color: themeProvider.textPrimary,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'BACK',
          style: GoogleFonts.ericaOne(
            color: themeProvider.primaryColor,
            fontSize: 32,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    ThemeProvider themeProvider,
    String queueName,
  ) {
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
                  'DELETE QUEUE?',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete "$queueName"? This action cannot be undone.',
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
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$queueName deleted'),
                        backgroundColor: themeProvider.backgroundColor,
                      ),
                    );
                  },
                  child: Text(
                    'DELETE',
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