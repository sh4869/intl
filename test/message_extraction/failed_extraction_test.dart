// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library failed_extraction_test;

import "message_extraction_test.dart";
import "dart:io";
import "package:unittest/unittest.dart";

main() {
  test("Expect warnings but successful extraction", () {
    runTestWithWarnings(warningsAreErrors: false, expectedExitCode: 0);
  });
}

const defaultFiles = const [
  "sample_with_messages.dart",
  "part_of_sample_with_messages.dart"
];

void runTestWithWarnings({bool warningsAreErrors, int expectedExitCode,
    bool embeddedPlurals: true, List<String> sourceFiles: defaultFiles}) {
  void verify(ProcessResult result) {
    try {
      expect(result.exitCode, expectedExitCode);
    } finally {
      deleteGeneratedFiles();
    }
  }

  copyFilesToTempDirectory();
  var program = asTestDirPath("../../bin/extract_to_arb.dart");
  var args = ["--output-dir=$tempDir"];
  if (warningsAreErrors) {
    args.add('--warnings-are-errors');
  }
  if (!embeddedPlurals) {
    args.add('--no-embedded-plurals');
  }
  var files = sourceFiles.map(asTempDirPath).toList();
  var allArgs = [program]
    ..addAll(args)
    ..addAll(files);
  var callback = expectAsync(verify);
  run(null, allArgs).then(callback);
}
