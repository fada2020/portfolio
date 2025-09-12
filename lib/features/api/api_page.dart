import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/state/openapi_state.dart';
import 'package:portfolio/utils/curl_builder.dart';

class ApiPage extends ConsumerWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search path, summary, operationId'),
                          onChanged: (v) => ref.read(apiSearchQueryProvider.notifier).state = v,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String?>(
                        value: selectedTag,
                        hint: const Text('Tag'),
                        onChanged: (v) => ref.read(apiSelectedTagProvider.notifier).state = v,
                        items: [
                          const DropdownMenuItem<String?>(value: null, child: Text('All')),
                          ...tags.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Row(children: [
                        const Text('Group by tag'),
                        Switch.adaptive(
                          value: groupByTag,
                          onChanged: (v) => ref.read(apiGroupByTagProvider.notifier).state = v,
                        ),
                      ]),
                    ],
                  ),
                  Row(
                    children: [
                      Row(children: [
                        const Text('Auth'),
                        Switch.adaptive(
                          value: includeAuth,
                          onChanged: (v) => ref.read(apiIncludeAuthProvider.notifier).state = v,
                        ),
                      ]),
                      const SizedBox(width: 8),
                      if (includeAuth)
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(prefixIcon: Icon(Icons.vpn_key), hintText: 'Bearer token'),
                            onChanged: (v) => ref.read(apiAuthTokenProvider.notifier).state = v,
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
                error: (e, st) => Center(child: Text('Failed to load: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text('Failed to load: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
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
            final key = (e.tags.isNotEmpty ? e.tags.first : 'Untagged');
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
                    for (final e in endpoints!)
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
      error: (e, st) => const Center(child: Text('Failed to load spec')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EndpointTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: methodColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(e.method, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(e.path, style: const TextStyle(fontFamily: 'monospace'))),
          ],
        ),
        subtitle: e.summary == null ? null : Text(e.summary!),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (e.tags.isNotEmpty) Wrap(spacing: 6, children: e.tags.map((t) => Chip(label: Text(t))).toList()),
          if ((e.operationId ?? '').isNotEmpty) Text('operationId: ${e.operationId}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          if (e.parameters.isNotEmpty) ...[
            Text('Parameters', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            _JsonBox(data: e.parameters
                .map((p) => {
                      'name': p.name,
                      'in': p.location,
                      'required': p.required,
                      if (p.schema != null) 'schema': p.schema,
                    })
                .toList()),
            const SizedBox(height: 8),
          ],
          if (e.requestBodySchema != null) ...[
            Text('Request Body (application/json)', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            _JsonBox(data: e.requestBodySchema!),
            const SizedBox(height: 8),
          ],
          if (e.responseSchema != null) ...[
            Text('Response (application/json, 2xx)', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            _JsonBox(data: e.responseSchema!),
            const SizedBox(height: 8),
          ],
          baseUrlAsync.when(
            data: (base) {
              final curl = curlBuilder(base);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('cURL', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      _CodeBox(text: curl),
                      IconButton(
                        tooltip: 'Copy',
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: curl));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied cURL')));
                        },
                      ),
                    ],
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
    final encoder = const JsonEncoder.withIndent('  ');
    final text = encoder.convert(data);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
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
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(text, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      ),
    );
  }
}

