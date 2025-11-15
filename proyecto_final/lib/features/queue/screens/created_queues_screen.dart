import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';
import 'package:proyecto_final/features/queue/screens/edit_queue_screen.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_model.dart';

class CreatedQueuesScreen extends StatefulWidget {
  const CreatedQueuesScreen({super.key});

  @override
  State<CreatedQueuesScreen> createState() => _CreatedQueuesScreenState();
}

class _CreatedQueuesScreenState extends State<CreatedQueuesScreen> {
  final QueueService _queueService = QueueService();

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
      child: Stack(
        children: [
          Container(
            width: double.infinity,
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
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: themeProvider.primaryColor,
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

  Widget _buildQueuesList(BuildContext context, ThemeProvider themeProvider) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid;

    if (userId == null) {
      return Expanded(
        child: Center(
          child: Text(
            'Please login to view your queues',
            style: GoogleFonts.lexendDeca(
              color: themeProvider.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

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
                  GestureDetector(
                    onTap: () {
                      _showInfoDialog(context, themeProvider);
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<QueueModel>>(
                stream: _queueService.getUserQueues(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: themeProvider.secondaryColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading queues: ${snapshot.error}',
                        style: GoogleFonts.lexendDeca(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final queues = snapshot.data ?? [];

                  if (queues.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.queue,
                            size: 80,
                            color: themeProvider.textPrimary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No queues yet',
                            style: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first queue to get started!',
                            style: GoogleFonts.lexendDeca(
                              color: themeProvider.textPrimary.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: queues.length,
                    itemBuilder: (context, index) {
                      return _buildQueueItem(
                        context,
                        themeProvider,
                        queues[index],
                      );
                    },
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

  Widget _buildQueueItem(BuildContext context, ThemeProvider themeProvider, QueueModel queue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/queue-qr',
            arguments: queue.id,
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    queue.title.toUpperCase(),
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${queue.currentCount}/${queue.maxPeople} people',
                    style: GoogleFonts.lexendDeca(
                      color: themeProvider.textPrimary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildActionButton(
              context,
              themeProvider,
              Icons.edit,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditQueueScreen(queueName: queue.title),
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
                _showDeleteConfirmationDialog(context, themeProvider, queue);
              },
            ),
          ],
        ),
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
    QueueModel queue,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                  'Are you sure you want to delete "${queue.title}"? This action cannot be undone.',
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
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    try {
                      await _queueService.deleteQueue(queue.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${queue.title} deleted'),
                            backgroundColor: themeProvider.secondaryColor,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting queue: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
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
                    Navigator.pop(dialogContext);
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

  void _showInfoDialog(BuildContext context, ThemeProvider themeProvider) {
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
            'Your Queues',
            style: GoogleFonts.ericaOne(
              color: themeProvider.secondaryColor,
              fontSize: 24,
            ),
          ),
          content: Text(
            'Here you can view, edit, and manage all the queues you have created. Tap on a queue to view its QR code.',
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
}