# ULSP (Unicon Language Server Protocol) Testing Guide

This document describes the comprehensive test suite for the Unicon Language Server Protocol implementation.

## Overview

The ULSP test suite consists of four main test categories:

1. **JSON-RPC Tests** - Test JSON-RPC protocol with a calculator server
2. **LSP Message Tests** - Test JSON-RPC message parsing and LSP protocol compliance
3. **LSP Feature Tests** - Test specific LSP features with realistic Unicon code
4. **LSP Protocol Tests** - Test the complete LSP server-client interaction

## Test Files

### Core Test Files

- `test_jsonrpc.icn` - Tests JSON-RPC protocol with calculator operations
- `test_lsp_message.icn` - Tests JSON-RPC message parsing and LSP request/response formats
- `test_lsp_feature.icn` - Tests specific LSP features (completion, hover, definition, etc.)
- `test_lsp_protocol.icn` - Integration tests with actual server-client communication
- `lsp_test_suite.icn` - Test suite runner that creates a UniconTestSuite and adds individual test files as Tests

### Test Data

- `test_feature.icn` - Sample Unicon code used for testing (created dynamically)
- Various test files created during test execution

## Running Tests

### Individual Test Suites

```bash
# Run JSON-RPC tests
make test_jsonrpc
./test_jsonrpc

# Run message parsing tests
make test_lsp_message
./test_lsp_message

# Run feature tests
make test_lsp_feature
./test_lsp_feature

# Run protocol tests
make test_lsp_protocol
./test_lsp_protocol

# Run all tests individually
make test-lsp
```

### Unified Test Runner

```bash
# Run comprehensive test suite (all tests)
make test
./lsp_test_suite
```

The unified test runner executes all four test suites sequentially and provides:
- Individual test suite results
- Aggregated test counts from all suites
- Overall pass/fail summary
- Success rate percentage

## Test Categories

### 1. JSON-RPC Tests (`test_jsonrpc.icn`)

Tests the fundamental JSON-RPC protocol with a calculator server:

#### Calculator Operations
- Addition (`+`) - Tests basic addition operations
- Subtraction (`-`) - Tests basic subtraction operations
- Multiplication (`*`) - Tests basic multiplication operations
- Division (`/`) - Tests basic division operations

#### Concurrent Testing
- Multiple concurrent requests
- Thread-safe request handling
- Response matching with request IDs

### 2. LSP Message Tests (`test_lsp_message.icn`)

Tests the fundamental JSON-RPC message handling:

#### JSON-RPC Message Parsing
- Valid request messages
- Valid notification messages
- Valid response messages
- Error response messages
- Malformed message handling

#### LSP Request Messages
- `initialize` - Server initialization
- `textDocument/completion` - Code completion
- `textDocument/hover` - Hover information
- `textDocument/definition` - Go to definition
- `textDocument/documentSymbol` - Document symbols
- `textDocument/foldingRange` - Code folding
- `textDocument/formatting` - Code formatting
- `shutdown` - Server shutdown

#### LSP Notification Messages
- `textDocument/didOpen` - Document opened
- `textDocument/didChange` - Document changed
- `textDocument/didClose` - Document closed
- `textDocument/didSave` - Document saved

#### Error Handling
- Unsupported method errors
- Malformed JSON handling
- Missing parameter validation

### 3. LSP Feature Tests (`test_lsp_feature.icn`)

Tests specific LSP features with realistic Unicon code:

#### Completion Features
- Keyword completion
- Variable completion
- Procedure completion
- Class completion
- Context-aware completion

#### Hover Features
- Procedure documentation
- Variable information
- Type information
- Signature information

#### Definition Features
- Procedure definitions
- Variable definitions
- Class definitions
- Method definitions

#### Symbol Features
- Document symbol extraction
- Symbol categorization
- Symbol range information
- Symbol hierarchy

#### Formatting Features
- Code indentation
- Line spacing
- Comment formatting
- Brace formatting

#### Folding Features
- Code block folding
- Comment folding
- Procedure folding
- Class folding

### 4. LSP Protocol Tests (`test_lsp_protocol.icn`)

Tests complete server-client interaction:

#### Server Initialization
- Capability negotiation
- Server configuration
- Database loading

#### Document Synchronization
- File opening
- Content changes
- File saving
- File closing

#### Feature Integration
- End-to-end completion
- End-to-end hover
- End-to-end definition
- End-to-end symbol extraction

## Test Data

### Sample Unicon Code

The tests use realistic Unicon code samples:

```unicon
procedure main()
    local x, y, result
    x := 10
    y := 20
    result := calculate(x, y)
    write("Result: ", result)
    return 0
end

procedure calculate(a, b)
    local sum, product
    sum := a + b
    product := a * b
    return sum + product
end

class TestClass()
    method new()
        return self
    end

    method get_value()
        return 42
    end
end
```

## Expected Test Results

### Message Tests
- All JSON-RPC message types should parse correctly
- LSP requests should generate proper responses
- Error conditions should be handled gracefully
- Malformed messages should be rejected appropriately

### Feature Tests
- Completion should provide relevant suggestions
- Hover should show appropriate information
- Definition should navigate to correct locations
- Symbols should be extracted and categorized correctly
- Formatting should improve code structure
- Folding should identify appropriate code blocks

### Protocol Tests
- Server should start and respond to requests
- Document synchronization should work correctly
- All LSP features should work end-to-end
- Error conditions should be handled gracefully

### JSON-RPC Tests
- All calculator operations should return correct results
- Concurrent requests should be handled correctly
- Request/response matching should work properly

## Test Configuration

### Environment Variables
- `ULSP_CAPTURE_EXPECTED` - Enable expected result capture mode (outputs JSON for copying into tests)
- `ULSP_TEST_VERBOSE` - Enable verbose test output
- `ULSP_TEST_TIMEOUT` - Set test timeout (default: 5000ms)
- `ULSP_TEST_PORT` - Set test server port (default: random)

### Test Options
- `-c` or `--capture` - Capture expected results (outputs JSON format for test validation)
- `-v` or `--verbose` - Verbose output
- `-t` - Test timeout in milliseconds
- `-p` - Server port number
- `-h` - Help information

### Capturing Expected Results

To capture expected results for test validation:

```bash
# Run tests in capture mode
./test_lsp_protocol -c
# or
ULSP_CAPTURE_EXPECTED=1 ./test_lsp_protocol
```

The test will output expected results in JSON format:
```
# EXPECTED RESULT for initialize (id=1):
# JSON format:
{"capabilities":{"completionProvider":true}}
# To use in test, parse with: jtous("{\"capabilities\":{\"completionProvider\":true}}")
```

Copy the JSON string and use it in your test:
```unicon
client.send_request("initialize", params, jtous("{\"capabilities\":{\"completionProvider\":true}}"))
```

## Debugging Tests

### Common Issues

1. **Port conflicts** - Tests use random ports, but conflicts can occur
2. **File permissions** - Test files need read/write access
3. **Dependencies** - All ULSP components must be built first
4. **Timing issues** - Server startup may take time

### Debug Output

Enable verbose output to see detailed test information:

```bash
./test_lsp_message -v
# or
ULSP_TEST_VERBOSE=1 ./test_lsp_message
```

### Test Logs

Test results are displayed in real-time with pass/fail indicators:
- `PASS:` - Test passed
- `FAIL:` - Test failed with details
- `✓` - Test suite passed
- `✗` - Test suite failed

## Continuous Integration

The test suite is designed to work in CI environments:

```bash
# Run unified test suite (recommended for CI)
make test
./lsp_test_suite

# Or run all tests individually
make test-lsp
```

Exit codes:
- `0` - All tests passed
- `1` - Some tests failed

The test suite runner (`lsp_test_suite`) provides:
- Aggregated test counts from all four test suites
- Overall pass/fail summary
- Detailed failure reporting

## Extending Tests

### Adding New Test Cases

1. Create test method in appropriate test class
2. Add test to test suite runner
3. Update documentation
4. Verify test passes

### Test Structure

All test files follow a consistent structure:

```unicon

global test_count, pass_count, fail_count

class MyTest()
   method run_all_tests()
      test_count := 0
      pass_count := 0
      fail_count := 0

      write("My Test Suite")
      write("========================================")

      # Run individual tests
      if test_feature1() then pass_count +:= 1 else fail_count +:= 1
      test_count +:= 1

      if test_feature2() then pass_count +:= 1 else fail_count +:= 1
      test_count +:= 1

      # Print results
      write("\n========================================")
      write("Test Results:")
      write("Total tests: ", test_count)
      write("Passed: ", pass_count)
      write("Failed: ", fail_count)

      if pass_count = test_count then
         return
   end

   method test_feature1()
      local result, expected

      write("\n--- Testing Feature 1 ---")

      # Execute test
      result := execute_test()
      expected := get_expected_result()

      # Verify result (use fail/return semantics)
      if result = expected then {
         write("PASS: Feature 1")
         return
      } else {
         write("FAIL: Feature 1 - expected ", expected, ", got ", result)
         fail
      }
   end
end

$ifdef STANDALONE
procedure main()
   local test_suite

   test_suite := MyTest()
   if test_suite.run_all_tests() then {
      exit(0)
   } else {
      exit(1)
   }
end
$endif
```

### Expected Result Validation

Tests can validate against expected results:

```unicon
# With expected result
client.send_request("initialize", params, jtous("{\"capabilities\":{\"completionProvider\":true}}"))

# Without expected result (structural validation only)
client.send_request("initialize", params, &null)
```

The test framework will:
- Compare actual vs expected when expected is provided
- Use structural validation when expected is null
- Output JSON-formatted results for easy copying


## Security Testing

Basic security tests are included:
- Malformed message handling
- Large message handling
- Invalid parameter validation
- Error message sanitization






