import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/state/openapi_state.dart';
import 'package:portfolio/utils/json_schema_sample.dart';
import 'package:portfolio/utils/curl_builder.dart';

class ApiPage extends ConsumerWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allAsync = ref.watch(openApiEndpointsProvider);
    final filteredAsync = ref.watch(filteredEndpointsProvider);
    final selectedTag = ref.watch(apiSelectedTagProvider);
    final groupByTag = ref.watch(apiGroupByTagProvider);
    final includeAuth = ref.watch(apiIncludeAuthProvider);

    return allAsync.when(
      data: (all) {
        final tags = all.expand((e) => e.tags).toSet().toList()..sort();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API Info Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.api, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Portfolio API',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ref.watch(openApiBaseUrlProvider).when(
                                data: (url) => Text(
                                  url,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                loading: () => const Text('Loading...'),
                                error: (_, __) => const Text('Error loading URL'),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => ref.refresh(openApiEndpointsProvider),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search and Filters
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: l10n.apiSearchHint,
                            labelText: l10n.apiSearchHint,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (v) => ref.read(apiSearchQueryProvider.notifier).state = v,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String?>(
                        value: selectedTag,
                        hint: Text(l10n.commonTag),
                        onChanged: (v) => ref.read(apiSelectedTagProvider.notifier).state = v,
                        items: [
                          DropdownMenuItem<String?>(value: null, child: Text(l10n.commonAll)),
                          ...tags.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Row(children: [
                        Text(l10n.apiGroupByTag),
                        Switch.adaptive(
                          value: groupByTag,
                          onChanged: (v) => ref.read(apiGroupByTagProvider.notifier).state = v,
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Advanced Options (Collapsible)
                  ExpansionTile(
                    title: const Text('Advanced Options'),
                    leading: const Icon(Icons.settings),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Column(
                          children: [
                            // Base URL Override
                            const Row(
                              children: [
                                Expanded(child: BaseUrlField(width: double.infinity)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Auth Settings
                            Row(
                              children: [
                                Row(children: [
                                  Text(l10n.apiIncludeAuth),
                                  Switch.adaptive(
                                    value: includeAuth,
                                    onChanged: (v) => ref.read(apiIncludeAuthProvider.notifier).state = v,
                                  ),
                                ]),
                                const SizedBox(width: 16),
                                if (includeAuth)
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.vpn_key),
                                        hintText: l10n.apiAuthToken,
                                        labelText: l10n.apiAuthToken,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (v) => ref.read(apiAuthTokenProvider.notifier).state = v,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: filteredAsync.when(
                data: (items) => _EndpointsList(items: items),
                error: (e, st) => Center(child: Text('${l10n.errFailedToLoad}: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text('${l10n.errFailedToLoad}: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class BaseUrlField extends ConsumerStatefulWidget {
  const BaseUrlField({required this.width});
  final double width;

  @override
  ConsumerState<BaseUrlField> createState() => _BaseUrlFieldState();
}

class _BaseUrlFieldState extends ConsumerState<BaseUrlField> {
  late final TextEditingController _controller;
  late final ProviderSubscription<String?> _overrideSubscription;

  @override
  void initState() {
    super.initState();
    final initialValue = ref.read(apiBaseUrlOverrideProvider) ?? '';
    _controller = TextEditingController(text: initialValue);
    _overrideSubscription = ref.listenManual<String?>(apiBaseUrlOverrideProvider, (previous, next) {
      final value = next ?? '';
      if (value != _controller.text) {
        _controller.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _overrideSubscription.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hint = ref.watch(openApiBaseUrlProvider).maybeWhen(orElse: () => null, data: (v) => v);
    return SizedBox(
      width: widget.width,
      child: TextField(
        key: const Key('api_base_url_field'),
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.link),
          labelText: l10n.apiBaseUrl,
          hintText: hint ?? l10n.apiBaseUrlOverrideHint,
        ),
        onChanged: (value) => ref.read(apiBaseUrlOverrideProvider.notifier).state = value.isEmpty ? null : value,
      ),
    );
  }
}

class _EndpointsList extends ConsumerWidget {
  const _EndpointsList({required this.items});
  final List<ApiEndpoint> items;

  Color _methodColor(String method, BuildContext context) {
    switch (method) {
      case 'GET':
        return Colors.green.shade600;
      case 'POST':
        return Colors.blue.shade600;
      case 'PUT':
        return Colors.orange.shade600;
      case 'DELETE':
        return Colors.red.shade600;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final baseUrlAsync = ref.watch(openApiBaseUrlProvider);
    final includeAuth = ref.watch(apiIncludeAuthProvider);
    final token = ref.watch(apiAuthTokenProvider);
    final specAsync = ref.watch(openApiSpecProvider);
    final groupByTag = ref.watch(apiGroupByTagProvider);

    return specAsync.when(
      data: (spec) {
        final components = (spec['components'] as Map?)?.cast<String, dynamic>();
        if (groupByTag) {
          final groups = <String, List<ApiEndpoint>>{};
          for (final e in items) {
            final key = (e.tags.isNotEmpty ? e.tags.first : l10n.apiUntagged);
            groups.putIfAbsent(key, () => []).add(e);
          }
          final tags = groups.keys.toList()..sort();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tags.length,
            itemBuilder: (context, i) {
              final tag = tags[i];
              final endpoints = groups[tag]!..sort((a, b) => a.path.compareTo(b.path));
              return Card(
                child: ExpansionTile(
                  title: Text(tag, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    for (final e in endpoints)
                      _EndpointTile(
                        e: e,
                        baseUrlAsync: baseUrlAsync,
                        components: components,
                        includeAuth: includeAuth,
                        token: token,
                        methodColor: _methodColor(e.method, context),
                        curlBuilder: (base) => buildCurl(e, base, includeAuth: includeAuth, token: token, components: components),
                      ),
                  ],
                ),
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final e = items[i];
            return _EndpointTile(
              e: e,
              baseUrlAsync: baseUrlAsync,
              components: components,
              includeAuth: includeAuth,
              token: token,
              methodColor: _methodColor(e.method, context),
              curlBuilder: (base) => buildCurl(e, base, includeAuth: includeAuth, token: token, components: components),
            );
          },
        );
      },
      error: (e, st) => Center(child: Text(l10n.errLoadSpec)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EndpointTile extends ConsumerWidget {
  const _EndpointTile({
    required this.e,
    required this.baseUrlAsync,
    required this.components,
    required this.includeAuth,
    required this.token,
    required this.methodColor,
    required this.curlBuilder,
  });
  final ApiEndpoint e;
  final AsyncValue<String> baseUrlAsync;
  final Map<String, dynamic>? components;
  final bool includeAuth;
  final String token;
  final Color methodColor;
  final String Function(String baseUrl) curlBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: methodColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                e.method,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.path,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (e.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  e.tags.first,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: e.summary == null ? null : Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            e.summary!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const SizedBox(height: 8),
          // Operation ID
          if ((e.operationId ?? '').isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.fingerprint, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('Operation ID: ${e.operationId}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Parameters Section
          if (e.parameters.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.settings, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.apiParameters, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            _JsonBox(data: e.parameters
                .map((p) => {
                      'name': p.name,
                      'in': p.location,
                      'required': p.required,
                      if (p.schema != null) 'schema': p.schema,
                    })
                .toList()),
            const SizedBox(height: 16),
          ],

          // Request Body Section
          if (e.requestBodySchema != null) ...[
            Row(
              children: [
                Icon(Icons.upload, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.apiRequestBodyJson, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            _JsonBox(data: e.requestBodySchema!),
            const SizedBox(height: 16),
          ],

          // Response Section
          if (e.responseSchema != null) ...[
            Row(
              children: [
                Icon(Icons.download, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.apiResponseJson, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            _JsonBox(data: e.responseSchema!),
            const SizedBox(height: 16),
          ],
          baseUrlAsync.when(
            data: (base) {
              final override = ref.watch(apiBaseUrlOverrideProvider);
              final effectiveBase = (override == null || override.isEmpty) ? base : override;
              final curl = curlBuilder(effectiveBase);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // cURL Section
                  Row(
                    children: [
                      Icon(Icons.code, size: 18, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(l10n.apiCurlTitle, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      _CodeBox(text: curl),
                      Semantics(
                        label: l10n.apiCopy,
                        button: true,
                        child: IconButton(
                          tooltip: l10n.apiCopy,
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: curl));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.apiCopiedCurl)));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),

                  // Try It Out Section
                  _TryBox(
                    e: e,
                    baseUrl: effectiveBase,
                    includeAuth: includeAuth,
                    token: token,
                    components: components,
                  ),
                ],
              );
            },
            error: (e, st) => const SizedBox.shrink(),
            loading: () => const SizedBox(height: 4, child: LinearProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class _JsonBox extends StatelessWidget {
  const _JsonBox({required this.data});
  final Object data;

  @override
  Widget build(BuildContext context) {
    const encoder = JsonEncoder.withIndent('  ');
    final text = encoder.convert(data);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(text, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(text, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      ),
    );
  }
}

class _TryBox extends StatefulWidget {
  const _TryBox({
    required this.e,
    required this.baseUrl,
    required this.includeAuth,
    required this.token,
    required this.components,
  });
  final ApiEndpoint e;
  final String baseUrl;
  final bool includeAuth;
  final String token;
  final Map<String, dynamic>? components;

  @override
  State<_TryBox> createState() => _TryBoxState();
}

class _TryBoxState extends State<_TryBox> {
  bool _loading = false;
  int? _status;
  Map<String, String>? _headers;
  String? _body;
  String? _error;
  int? _durationMs;
  String? _lastUrl;
  late final TextEditingController _bodyController;
  bool _supportsBody = false;

  @override
  void initState() {
    super.initState();
    _supportsBody = const {'POST', 'PUT', 'PATCH'}.contains(widget.e.method.toUpperCase());
    String initial = '';
    if (_supportsBody && widget.e.requestBodySchema != null) {
      final schema = widget.e.requestBodySchema!;
      final obj = sampleFromSchemaWithComponents(schema, widget.components ?? const {});
      initial = const JsonEncoder.withIndent('  ').convert(obj);
    }
    _bodyController = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  String _buildUrl() {
    String path = widget.e.path;
    for (final p in widget.e.parameters.where((p) => p.location == 'path')) {
      final isNum = (p.schema?['type'] == 'integer' || p.schema?['type'] == 'number');
      path = path.replaceAll('{${p.name}}', isNum ? '1' : 'value');
    }
    final qp = <String, String>{};
    for (final p in widget.e.parameters.where((p) => p.location == 'query')) {
      final sch = p.schema ?? {};
      final val = sch['default'] ?? (sch['type'] == 'integer' || sch['type'] == 'number' ? 0 : 'value');
      if (p.required) qp[p.name] = '$val';
    }
    final base = widget.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final query = qp.isEmpty ? '' : '?${qp.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
    return '$base$path$query';
  }

  Future<void> _exec(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
      _status = null;
      _headers = null;
      _body = null;
      _error = null;
    });
    try {
      final url = _buildUrl();
      _lastUrl = url;
      final uri = Uri.parse(url);
      final headers = <String, String>{'accept': 'application/json'};
      if (widget.includeAuth && widget.token.isNotEmpty) {
        headers['authorization'] = 'Bearer ${widget.token}';
      }
      http.Response res;
      final sw = Stopwatch()..start();
      final m = widget.e.method.toUpperCase();
      if (m == 'GET') {
        res = await http.get(uri, headers: headers);
      } else if (m == 'DELETE') {
        res = await http.delete(uri, headers: headers);
      } else if (_supportsBody) {
        headers['content-type'] = 'application/json';
        dynamic data;
        try {
          data = _bodyController.text.trim().isEmpty ? {} : jsonDecode(_bodyController.text);
        } catch (e) {
          throw Exception('Invalid JSON body: $e');
        }
        final bodyStr = jsonEncode(data);
        if (m == 'POST') {
          res = await http.post(uri, headers: headers, body: bodyStr);
        } else if (m == 'PUT') {
          res = await http.put(uri, headers: headers, body: bodyStr);
        } else if (m == 'PATCH') {
          res = await http.patch(uri, headers: headers, body: bodyStr);
        } else {
          res = await http.get(uri, headers: headers); // fallback
        }
      } else {
        res = await http.get(uri, headers: headers);
      }
      sw.stop();
      String bodyText;
      final ct = res.headers['content-type'] ?? '';
      if (ct.contains('application/json')) {
        try {
          final obj = jsonDecode(res.body);
          bodyText = const JsonEncoder.withIndent('  ').convert(obj);
        } catch (_) {
          bodyText = res.body;
        }
      } else {
        bodyText = res.body.length > 4000 ? '${res.body.substring(0, 4000)}…' : res.body;
      }
      setState(() {
        _status = res.statusCode;
        _headers = res.headers;
        _body = bodyText;
        _durationMs = sw.elapsedMilliseconds;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.play_circle_outline, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.apiTry} (${widget.e.method.toUpperCase()})',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _loading ? null : () => _exec(context),
                    icon: _loading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow),
                    label: Text(l10n.apiExecute),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_supportsBody) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.edit_note, size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                l10n.apiRequestBodyJson,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bodyController,
            maxLines: 6,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter JSON request body...',
              helperText: 'Modify the JSON below and click Execute to test',
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ],
        if (_lastUrl != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: Text(_lastUrl!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))),
              IconButton(
                tooltip: l10n.apiCopyUrl,
                icon: const Icon(Icons.link),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _lastUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.apiCopiedUrl)));
                },
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        const SizedBox(height: 16),

        // Response Section
        if (_error != null || _status != null) ...[
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.featured_play_list, size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Response',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Error Display
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Success Response
        if (_status != null) ...[
          // Status and Duration
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _status! >= 200 && _status! < 300
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _status! >= 200 && _status! < 300 ? Icons.check_circle : Icons.error,
                  color: _status! >= 200 && _status! < 300
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.apiStatus}: $_status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _status! >= 200 && _status! < 300
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                if (_durationMs != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    '${l10n.apiDuration}: ${_durationMs}ms',
                    style: TextStyle(
                      color: _status! >= 200 && _status! < 300
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Headers
          Row(
            children: [
              Icon(Icons.list, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(l10n.apiHeaders, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          _JsonBox(data: _headers ?? {}),
          const SizedBox(height: 12),

          // Response Body
          Row(
            children: [
              Icon(Icons.data_object, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(l10n.apiBody, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.topRight,
            children: [
              _CodeBox(text: _body ?? ''),
              IconButton(
                tooltip: l10n.apiCopyBody,
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _body ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.apiCopiedBody)));
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
