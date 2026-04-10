// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  // Run dart analyze
  final target = args.isNotEmpty ? args[0] : '.';
  print('Running dart analyze --format json $target ...');
  final result = await Process.run('dart', [
    'analyze',
    '--format',
    'json',
    target,
  ]);
  final input = result.stdout as String;

  if (input.trim().isEmpty) {
    print('No output from dart analyze.');
    return;
  }

  if (input.trim().isEmpty) {
    print('No input provided.');
    return;
  }

  final Map<String, dynamic> data = jsonDecode(input);
  final List<dynamic> diagnostics = data['diagnostics'] ?? [];

  final Map<String, int> codeCounts = {};
  final Map<String, Set<String>> codeFiles = {};

  for (final diag in diagnostics) {
    final String code = diag['code'] ?? 'unknown';
    final String file = diag['location']['file'] ?? 'unknown';

    codeCounts[code] = (codeCounts[code] ?? 0) + 1;
    codeFiles.putIfAbsent(code, () => {}).add(file);
  }

  final sortedCodes = codeCounts.keys.toList()
    ..sort((a, b) => codeCounts[b]!.compareTo(codeCounts[a]!));

  int totalOccurrences = 0;
  final Set<String> allAffectedFiles = {};

  for (final code in sortedCodes) {
    totalOccurrences += codeCounts[code]!;
    allAffectedFiles.addAll(codeFiles[code]!);
  }

  // Calculate widths
  int ruleWidth = 'Lint Rule'.length;
  int occurrencesWidth = 'Occurrences'.length;
  int filesWidth = 'Files Affected'.length;

  for (final code in sortedCodes) {
    final ruleStr = '`$code`';
    if (ruleStr.length > ruleWidth) ruleWidth = ruleStr.length;

    final countStr = codeCounts[code]!.toString();
    if (countStr.length > occurrencesWidth) occurrencesWidth = countStr.length;

    final fileStr = codeFiles[code]!.length.toString();
    if (fileStr.length > filesWidth) filesWidth = fileStr.length;
  }

  final totalRuleStr = '**Total**';
  if (totalRuleStr.length > ruleWidth) ruleWidth = totalRuleStr.length;

  final totalOccurrencesStr = '**$totalOccurrences**';
  if (totalOccurrencesStr.length > occurrencesWidth) {
    occurrencesWidth = totalOccurrencesStr.length;
  }

  final totalFilesStr = '**${allAffectedFiles.length}**';
  if (totalFilesStr.length > filesWidth) filesWidth = totalFilesStr.length;

  // Print header
  print(
    '| ${'Lint Rule'.padRight(ruleWidth)} | ${'Occurrences'.padRight(occurrencesWidth)} | ${'Files Affected'.padRight(filesWidth)} |',
  );

  // Print separator
  final ruleSep = ':${'-' * (ruleWidth - 1)}';
  final occSep = ':${'-' * (occurrencesWidth - 2)}:';
  final fileSep = ':${'-' * (filesWidth - 2)}:';
  print('| $ruleSep | $occSep | $fileSep |');

  // Print data
  for (final code in sortedCodes) {
    final ruleStr = '`$code`'.padRight(ruleWidth);
    final countStr = codeCounts[code]!.toString().padRight(occurrencesWidth);
    final fileStr = codeFiles[code]!.length.toString().padRight(filesWidth);
    print('| $ruleStr | $countStr | $fileStr |');
  }

  // Print total
  print(
    '| ${totalRuleStr.padRight(ruleWidth)} | ${totalOccurrencesStr.padRight(occurrencesWidth)} | ${totalFilesStr.padRight(filesWidth)} |',
  );
}
