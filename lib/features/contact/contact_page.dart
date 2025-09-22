import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/profile_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const _contactEmail = 'hyeogjui4@gmail.com';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create mailto URL with form data
      final emailBody = '''
Name: ${_nameController.text}
Email: ${_emailController.text}
Subject: ${_subjectController.text}

Message:
${_messageController.text}
''';

      final mailtoUrl = Uri(
        scheme: 'mailto',
        path: _contactEmail,
        queryParameters: {
          'subject': _subjectController.text,
          'body': emailBody,
        },
      );

      if (await canLaunchUrl(mailtoUrl)) {
        await launchUrl(mailtoUrl);
        setState(() {
          _showSuccessMessage = true;
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
        });
      } else {
        throw Exception('mailto unavailable');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.contactMailFallbackError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        await _showManualEmailDialog(l10n);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showManualEmailDialog(AppLocalizations l10n) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.contactMailFallbackTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.contactMailFallbackDescription(_contactEmail)),
              const SizedBox(height: 12),
              SelectableText(
                _contactEmail,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _copyEmailToClipboard(l10n);
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.contactCopyEmail),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _copyEmailToClipboard(AppLocalizations l10n) async {
    await Clipboard.setData(const ClipboardData(text: _contactEmail));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.contactCopiedEmail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header section
            Center(
              child: Column(
                children: [
                  Text(
                    l10n.contactTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.contactSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Main content layout
            Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact form
                Expanded(
                  flex: isWide ? 2 : 1,
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.contactFormTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (_showSuccessMessage) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      l10n.contactFormSuccess,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: l10n.contactFormName,
                                    hintText: l10n.contactFormNameHint,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.contactFormNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: l10n.contactFormEmail,
                                    hintText: l10n.contactFormEmailHint,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.contactFormEmailRequired;
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return l10n.contactFormEmailInvalid;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _subjectController,
                                  decoration: InputDecoration(
                                    labelText: l10n.contactFormSubject,
                                    hintText: l10n.contactFormSubjectHint,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.subject),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.contactFormSubjectRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    labelText: l10n.contactFormMessage,
                                    hintText: l10n.contactFormMessageHint,
                                    border: const OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                  maxLines: 6,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.contactFormMessageRequired;
                                    }
                                    if (value.trim().length < 10) {
                                      return l10n.contactFormMessageTooShort;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _isSubmitting ? null : _submitForm,
                                    icon: _isSubmitting
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.send),
                                    label: Text(_isSubmitting
                                        ? l10n.contactFormSending
                                        : l10n.contactFormSend),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (isWide) const SizedBox(width: 24),
                if (!isWide) const SizedBox(height: 24),

                // Contact information
                Expanded(
                  flex: 1,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final localeCode = Localizations.localeOf(context).languageCode;
                      final profileAsync = ref.watch(profileProvider(localeCode));

                      return profileAsync.when(
                    data: (profile) {
                      final links = profile.links;
                      return Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.contactInfoTitle,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Text(
                                l10n.contactInfoDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 24),

                              // Contact links
                              if (links['email'] != null) ...[
                                _ContactLink(
                                  icon: Icons.email,
                                  label: links['email']!,
                                  onTap: () => launchUrl(Uri.parse('mailto:${links['email']}')),
                                ),
                                const SizedBox(height: 12),
                              ],

                              if (links['github'] != null) ...[
                                _ContactLink(
                                  icon: Icons.code,
                                  label: 'GitHub',
                                  onTap: () => launchUrl(Uri.parse(links['github']!)),
                                ),
                                const SizedBox(height: 12),
                              ],

                              if (links['linkedin'] != null) ...[
                                _ContactLink(
                                  icon: Icons.business,
                                  label: 'LinkedIn',
                                  onTap: () => launchUrl(Uri.parse(links['linkedin']!)),
                                ),
                                const SizedBox(height: 12),
                              ],

                              const SizedBox(height: 16),
                              Text(
                                l10n.contactResponseTime,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    error: (e, st) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Failed to load contact information: $e'),
                      ),
                    ),
                        loading: () => const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Icon(Icons.open_in_new, size: 16),
          ],
        ),
      ),
    );
  }
}
