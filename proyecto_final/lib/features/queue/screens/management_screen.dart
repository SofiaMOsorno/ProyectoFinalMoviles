import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_member_model.dart';
import 'package:proyecto_final/models/queue_model.dart';

class ManagementScreen extends StatefulWidget {
  final String queueName;
  final String queueId;

  const ManagementScreen({
    super.key,
    required this.queueName,
    required this.queueId,
  });

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final QueueService _queueService = QueueService();
  bool _showUsernames = false;
  QueueModel? _queueData;

  @override
  void initState() {
    super.initState();
    _loadQueueData();
  }

  Future<void> _loadQueueData() async {
    try {
      final queue = await _queueService.getQueue(widget.queueId);
      if (mounted) {
        setState(() {
          _queueData = queue;
        });
      }
    } catch (e) {
      // Handle error silently, button will just not show
    }
  }

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
                child: StreamBuilder<List<QueueMemberModel>>(
                  stream: _queueService.getQueueMembers(widget.queueId),
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
                          'Error loading members',
                          style: GoogleFonts.lexendDeca(
                            color: themeProvider.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final members = snapshot.data ?? [];

                    return Column(
                      children: [
                        _buildQueueInfo(themeProvider, members.length),
                        Expanded(
                          child: _buildQueueList(themeProvider, members),
                        ),
                        _buildBottomControls(context, themeProvider),
                      ],
                    );
                  },
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

  Widget _buildQueueInfo(ThemeProvider themeProvider, int memberCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: themeProvider.backgroundColor,
      child: Text(
        'People in your queue: $memberCount',
        style: GoogleFonts.lexendDeca(
          color: themeProvider.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQueueList(ThemeProvider themeProvider, List<QueueMemberModel> members) {
    if (members.isEmpty) {
      return Center(
        child: Text(
          'No members in queue yet',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 18,
          ),
        ),
      );
    }

    return Container(
      color: themeProvider.backgroundColor,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: members.length,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Material(
                color: Colors.transparent,
                elevation: 8,
                child: child,
              );
            },
            child: child,
          );
        },
        onReorder: (int oldIndex, int newIndex) async {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final reorderedMembers = List<QueueMemberModel>.from(members);
          final item = reorderedMembers.removeAt(oldIndex);
          reorderedMembers.insert(newIndex, item);

          try {
            await _queueService.reorderMembers(
              queueId: widget.queueId,
              members: reorderedMembers,
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error reordering: $e')),
              );
            }
          }
        },
        itemBuilder: (context, index) {
          return _buildQueueMemberItem(
            themeProvider,
            members[index],
            index,
          );
        },
      ),
    );
  }

  Widget _buildQueueMemberItem(ThemeProvider themeProvider, QueueMemberModel member, int index) {
    final displayName = _showUsernames ? member.username : '${index + 1}';

    return Container(
      key: ValueKey(member.id),
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
              Icons.drag_handle,
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
                displayName,
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
                _showRemoveUserDialog(member, themeProvider);
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      color: themeProvider.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_queueData?.maxPeople != null) ...[
            _buildAllowMoreUsersButton(themeProvider),
            const SizedBox(height: 8),
          ],
          _buildSeeQRButton(themeProvider),
          const SizedBox(height: 8),
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
      height: 50,
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSeeQRButton(ThemeProvider themeProvider) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/queue-qr',
          arguments: widget.queueId,
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
      mainAxisSize: MainAxisSize.min,
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
        GestureDetector(
          onTap: () {
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
                    'Show Usernames',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.secondaryColor,
                      fontSize: 24,
                    ),
                  ),
                  content: Text(
                    'When enabled, the list will display usernames instead of positions.',
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
            borderRadius: BorderRadius.circular(15),
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
            fontSize: 32,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  void _showRemoveUserDialog(QueueMemberModel member, ThemeProvider themeProvider) {
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
                  'REMOVE USER?',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to remove "${member.username}" from the queue?',
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
                      await _queueService.removeMemberFromQueue(
                        queueId: widget.queueId,
                        memberId: member.id,
                      );

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${member.username} removed from queue'),
                            backgroundColor: themeProvider.backgroundColor,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error removing user: $e')),
                        );
                      }
                    }
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
}