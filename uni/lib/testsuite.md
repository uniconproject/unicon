# Unicon Test Suite

This document describes the `UniconTestSuite` testing framework, including its design, terminology, API, and potential future enhancements. The framework was developed from scratch for the Unicon Language Server Protocol (ULSP) project.

## Terminology

This section defines key terms used throughout this document and the testing framework.

### Test Hierarchy

The testing framework uses a hierarchical structure with the following levels:

1. **Test Suite** (`UniconTestSuite`): The top-level container that manages a collection of Tests. A test suite handles test execution, reporting, and aggregation of results across all its Tests. **Typically, a Test Suite is a collection of test files** (e.g., `lsp_run_tests.icn` that runs multiple test files like `jsonrpc_test.icn`, `lsp_message_test.icn`, etc.).

2. **Test**: A logical grouping of related Test Cases, organized into Test Sections. A Test represents a major functional area or feature being tested (e.g., "JSON-RPC Tests", "LSP Message Tests"). **Typically, a Test corresponds to a single test file** (e.g., `test_jsonrpc.icn`, `test_lsp_message.icn`, `test_lsp_protocol.icn`). **Test file names must start with "test_"** (e.g., `test_jsonrpc.icn`, not `jsonrpc_test.icn`). Each test file contains one or more Test Sections with their associated Test Cases.

3. **Test Section**: A subdivision within a Test that groups related Test Cases. Test Sections help organize Test Cases into logical categories (e.g., "Initialization", "Document Synchronization", "Completion").

4. **Test Case**: A single unit of testing that verifies a specific behavior or functionality. A Test Case is a procedure that returns on success and fails on failure (following Unicon's success/failure semantics). **Test Case procedure names must start with "test_"** (e.g., `test_addition`, `test_initialize`, `test_completion`). Test Cases can contain multiple Test Steps.

5. **Test Step**: The smallest unit of testing within a Test Case. A Test Step represents a single assertion or verification point. Multiple Test Steps combine to form a complete Test Case.

### Hierarchy Example

```
Test Suite: ULSP Test Suite
  └─ Test: JSON-RPC Tests
       └─ Test Section: Calculator Operations
            ├─ Test Case: test_addition
            │    ├─ Test Step: assert_equal(2 + 3, 5)
            │    ├─ Test Step: assert_equal(10 + 20, 30)
            │    └─ Test Step: assert_equal(0 + 0, 0)
            ├─ Test Case: test_subtraction
            │    ├─ Test Step: assert_equal(5 - 3, 2)
            │    └─ Test Step: assert_equal(10 - 7, 3)
            └─ Test Case: test_multiplication
                 ├─ Test Step: assert_equal(2 * 3, 6)
                 └─ Test Step: assert_equal(4 * 5, 20)
  └─ Test: LSP Message Tests
       └─ Test Section: Message Parsing
            ├─ Test Case: test_jsonrpc_parsing
            │    ├─ Test Step: assert_not_null(msg)
            │    └─ Test Step: assert_equal(msg.get_kind(), "request")
            ├─ Test Case: test_initialize_request
            │    ├─ Test Step: assert_equal(msg.get_method(), "initialize")
            │    └─ Test Step: assert_not_null(msg.get_params())
            └─ Test Case: test_notification_parsing
                 ├─ Test Step: assert_equal(msg.get_kind(), "notification")
                 └─ Test Step: assert_equal(msg.get_method(), "textDocument/didOpen")
  └─ Test: LSP Protocol Tests
       ├─ Test Section: Initialization
       │    └─ Test Case: test_initialize
       │         ├─ Test Step: assert_not_null(response)
       │         ├─ Test Step: assert_not_null(response.get_result())
       │         └─ Test Step: assert_not_null(response.get_result()["capabilities"])
       ├─ Test Section: Document Synchronization
       │    ├─ Test Case: test_document_sync
       │    │    ├─ Test Step: send_notification("textDocument/didOpen", params)
       │    │    ├─ Test Step: send_notification("textDocument/didChange", params)
       │    │    └─ Test Step: send_notification("textDocument/didSave", params)
       │    └─ Test Case: test_document_open
       │         ├─ Test Step: assert{client.is_connected()}
       │         └─ Test Step: assert_not_null(document_uri)
       ├─ Test Section: Completion
       │    └─ Test Case: test_completion
       │         ├─ Test Step: assert_not_null(completion_list)
       │         ├─ Test Step: assert{*completion_list["items"] > 0}
       │         └─ Test Step: assert_equal(completion_list["items"][1]["label"], "write")
       ├─ Test Section: Hover
       │    └─ Test Case: test_hover
       │         ├─ Test Step: assert_not_null(hover_result)
       │         └─ Test Step: assert_not_null(hover_result["contents"])
       ├─ Test Section: Definition
       │    └─ Test Case: test_definition
       │         ├─ Test Step: assert_not_null(definition_result)
       │         └─ Test Step: assert_not_null(definition_result["uri"])
       ├─ Test Section: Document Symbols
       │    └─ Test Case: test_document_symbols
       │         ├─ Test Step: assert_not_null(symbols)
       │         └─ Test Step: assert{*symbols > 0}
       ├─ Test Section: Folding Ranges
       │    └─ Test Case: test_folding_ranges
       │         ├─ Test Step: assert_not_null(folding_ranges)
       │         └─ Test Step: assert{*folding_ranges > 0}
       ├─ Test Section: Formatting
       │    └─ Test Case: test_formatting
       │         ├─ Test Step: assert_not_null(formatted_text)
       │         └─ Test Step: assert_equal(*formatted_text, expected_length)
       ├─ Test Section: Error Handling
       │    └─ Test Case: test_error_handling
       │         ├─ Test Step: assert_not_null(error_response)
       │         └─ Test Step: assert_equal(error_response["error"]["code"], -32602)
       └─ Test Section: Shutdown
            └─ Test Case: test_shutdown
                 ├─ Test Step: send_request("shutdown", [], &null)
                 ├─ Test Step: send_notification("exit", [])
                 └─ Test Step: assert{client.disconnect()}
```

### Core Concepts

- **Test Suite** (`UniconTestSuite`): A collection of related Tests organized hierarchically. A test suite manages test execution, reporting, and aggregation of results. **A Test Suite typically corresponds to a collection of test files** (e.g., `lsp_run_tests.icn` that orchestrates multiple test files).

- **Test**: A major functional grouping within a Test Suite. Tests are typically organized by feature area or component. Each Test can contain multiple Test Sections. **A Test typically corresponds to a single test file** (e.g., `test_jsonrpc.icn`, `test_lsp_message.icn`). **Test file names must start with "test_"** (e.g., `test_jsonrpc.icn`, not `jsonrpc_test.icn`). Each test file contains the Test Sections and Test Cases for that functional area.

- **Test Section**: A logical grouping of related Test Cases within a Test. Test Sections help organize Test Cases into categories and appear in the test output with hierarchical numbering (e.g., "1.1", "2.3.1").

- **Test Case**: A single unit of testing that verifies a specific behavior or functionality. A Test Case is a procedure that returns on success and fails on failure (following Unicon's success/failure semantics). **Test Case procedure names must start with "test_"** (e.g., `test_addition`, `test_initialize`, `test_completion`). A Test Case may contain multiple Test Steps (assertions).

- **Test Step**: An individual assertion or verification point within a Test Case. Test Steps are the atomic units of verification (e.g., `assert_equal()`, `assert_not_null()`). Multiple Test Steps combine to form a complete Test Case.

- **Assertion**: A statement that verifies an expected condition. Assertions use Unicon's success/failure semantics - they return on success and fail on failure. Examples: `assert_equal()`, `assert_not_null()`, `assert()`.

- **Test Fixture**: Setup and teardown code that runs before and after tests. Fixtures ensure tests run in a known state and clean up resources.

- **Setup**: Code that runs before a test (or all tests) to prepare the test environment.

- **Teardown**: Code that runs after a test (or all tests) to clean up resources and restore state.

- **Test Runner**: The component that executes tests, collects results, and generates reports. In `UniconTestSuite`, the `run_all_tests()` method acts as the test runner.

### Output Styles

- **Short Style**: Concise output format, showing dots (`.`) for passing tests, `F` for failures, and `s` for skipped tests. Includes a summary line at the end.

- **Long Style**: Detailed output format, showing hierarchical test numbers, status, timing, and descriptions in a structured table format.

- **Debug Style**: Verbose output format showing detailed information for each test, including descriptions, timing, and full status information.

### Test States

- **Pass**: A test that executed successfully and all assertions passed.

- **Fail**: A test that failed due to a failed assertion or an error during execution.

- **Skip**: A test that was intentionally skipped (not executed) due to conditions not being met (e.g., platform not supported, feature unavailable).

- **Error**: A test that encountered an unexpected error during execution (distinct from a failed assertion).

### Test Organization

- **Hierarchical Numbering**: Test numbering system that reflects the hierarchy. For example, "1.2.3" represents the third Test Case in the second Test Section of the first Test.

- **Test Registration**: The process of adding Tests, Test Sections, and Test Cases to a test suite using methods like `add_test()`, `add_test_section()`, etc.

- **Test Discovery**: Automatic finding and loading of Test Cases from source files, typically by naming convention. **Test files must start with "test_"** and **Test Case procedures must also start with "test_"** (e.g., file `test_jsonrpc.icn` contains procedure `test_addition`).

### Implementation

The `UniconTestSuite` implementation supports the full hierarchy:
- **Test Suite** (`UniconTestSuite`) - matches the terminology
- **Tests** (`add_test(name)`) - registers a Test (second level)
- **Test Sections** (`add_test_section(name)`) - registers a Test Section within a Test (third level)
- **Test Cases** (`add_test_case(name, test_proc, description)`) - registers a Test Case within a Test Section (fourth level)
- **Test Steps** - implicit (assertions within Test Case procedures)

The `add_test(name, test_proc, description)` method can be used in two ways: When called with only a name, it registers a Test. When called with name, test_proc, and description, it registers a Test Case.

The framework supports the hierarchy:
- Test Suite → Tests → Test Sections → Test Cases → Test Steps

The hierarchical numbering reflects this structure (e.g., "1.2.3" = Test 1, Section 2, Case 3).

### Naming Conventions

The framework enforces the following naming conventions:

- **Test Files**: Must start with `"test_"` prefix (e.g., `test_jsonrpc.icn`, `test_lsp_message.icn`, `test_lsp_protocol.icn`)
- **Test Case Procedures**: Must start with `"test_"` prefix (e.g., `test_addition`, `test_initialize`, `test_completion`)

These conventions enable:
- **Test Discovery**: Automatic finding of test files and test procedures by naming pattern
- **Consistency**: Clear identification of test-related code
- **Tooling Support**: IDE and build tools can easily identify and run tests

**Examples**:
- ✅ Valid: File `test_jsonrpc.icn` contains procedure `test_addition`
- ✅ Valid: File `test_lsp_protocol.icn` contains procedure `test_initialize`
- ❌ Invalid: File `jsonrpc_test.icn` (should be `test_jsonrpc.icn`)
- ❌ Invalid: Procedure `addition_test` (should be `test_addition`)

### Assertion Types

- **Equality Assertion**: Verifies that two values are equal (e.g., `assert_equal()`).

- **Inequality Assertion**: Verifies that two values are not equal (e.g., `assert_not_equal()`).

- **Boolean Assertion**: Verifies a boolean condition (e.g., `assert()`, `assert_not()`).

- **Null Assertion**: Verifies null or non-null values (e.g., `assert_null()`, `assert_not_null()`).

- **Containment Assertion**: Verifies that a value is contained in a container (e.g., `assert_contains()` - proposed).

- **Pattern Assertion**: Verifies that a string matches a pattern (e.g., `assert_matches()` - proposed).

- **Approximate Assertion**: Verifies floating-point equality within a tolerance (e.g., `assert_approx_equal()` - proposed).

### Advanced Concepts

- **Parameterized Test**: A test that runs multiple times with different input parameters, reducing code duplication.

- **Mock Object**: A fake object that simulates the behavior of a real object for testing purposes.

- **Stub**: A simplified implementation of a dependency used for testing.

- **Test Coverage**: A measure of how much of the codebase is executed by tests.

- **Test Timeout**: A maximum time limit for test execution, used to catch hanging tests.

- **Test Filtering**: The ability to run only a subset of tests based on criteria (name pattern, tags, etc.).

## Function Name Reorganization

This section proposes improvements to the API naming and organization for better consistency and usability.

### API

```unicon
suite := UniconTestSuite()
suite.set_verbose(flag)
suite.set_output_style(style)
suite.add_test_section(name)        # Adds a Test Section
suite.add_test_subsection(name)     # Adds a nested Test Section
suite.end_test_section()            # Ends Test Section
suite.add_test(name, test_proc, description)  # Adds a Test Case (not a Test!)
suite.run_all_tests()
```

**Note**: The `add_test()` method can register either a **Test** (when called with only a name) or a **Test Case** (when called with name, test_proc, and description).

### Proposed API Improvements

#### 1. Simplify Method Names

**Proposed Changes:**
- `set_verbose(flag)` → `verbose(flag)` or `set_verbosity(flag)`
  - **Rationale**: Shorter, more concise. Alternative `set_verbosity()` is more explicit about what's being set.

- `set_output_style(style)` → `output_style(style)` or keep as-is
  - **Rationale**: `set_output_style()` is clear and follows a common pattern. Could be shortened to `output_style()` for consistency.

- `add_test_section(name)` → `section(name)` or `begin_section(name)`
  - **Rationale**: Shorter, more intuitive. The "add" prefix is redundant since we're clearly adding something.

- `add_test_subsection(name)` → `subsection(name)` or `begin_subsection(name)`
  - **Rationale**: Consistent with section naming, shorter.

- `end_test_section()` → `end_section()` or remove (use block-based approach)
  - **Rationale**: Shorter, consistent. Alternatively, consider a block-based approach that doesn't require explicit ending.

- `add_test(name, test_proc, description)` → `test_case(name, test_proc, description)` or `add_test_case(name, test_proc, description)`
  - **Rationale**: More accurate - this registers a Test Case, not a Test. Alternatively, keep `test()` as shorthand but document that it registers Test Cases.

- `run_all_tests()` → `run()` or keep as-is
  - **Rationale**: `run_all_tests()` is explicit but verbose. `run()` is shorter but less clear. Consider keeping for clarity.

#### 2. Fluent/Builder Pattern (Optional Enhancement)

Consider supporting a fluent interface for better readability:

```unicon
suite := UniconTestSuite()
   .verbose(1)
   .output_style("long")
   .section("Basic Tests")
      .test("test_math", test_math, "Test basic math")
      .test("test_strings", test_strings, "Test strings")
   .section("Advanced Tests")
      .subsection("Nested Tests")
         .test("test_nested", test_nested, "Test nested")
   .run()
```

This would require methods to return `self` for chaining.

#### 3. Alternative: Block-Based Sections

Consider a block-based approach for sections (if Unicon supports it):

```unicon
suite.section("Basic Tests") {
   suite.test("test_math", test_math, "Test basic math")
   suite.test("test_strings", test_strings, "Test strings")
}
```

This would eliminate the need for `end_test_section()`.

#### 4. Recommended Naming Convention

**Proposed Standard API:**

```unicon
# Configuration
suite := UniconTestSuite()
suite.set_verbosity(flag)           # or: suite.verbose(flag)
suite.set_output_style(style)        # or: suite.output_style(style)

# Test Organization (Test Sections)
suite.section(name)                 # Begin new top-level Test Section
suite.subsection(name)             # Begin nested Test Section
suite.end_section()                # End Test Section (if needed)

# Test Registration (Test Cases)
suite.test_case(name, test_proc, description)  # Register a Test Case
# or shorthand:
suite.test(name, test_proc, description)       # Shorthand for test_case()

# Execution
suite.run()                         # or: suite.run_all_tests()
```

**Alternative (More Explicit):**

```unicon
# Configuration
suite.set_verbosity(flag)
suite.set_output_style(style)

# Test Organization (Test Sections)
suite.begin_section(name)           # Begin new top-level Test Section
suite.begin_subsection(name)       # Begin nested Test Section
suite.end_section()                # End Test Section

# Test Registration (Test Cases)
suite.register_test_case(name, test_proc, description)  # Register a Test Case

# Execution
suite.run_all_tests()
```

### Summary of Proposed Changes

| Name | Proposed Name | Priority | Rationale |
|-------------|---------------|----------|-----------|
| `set_verbose()` | `set_verbosity()` or `verbose()` | Medium | More explicit or more concise |
| `set_output_style()` | Keep as-is or `output_style()` | Low | Already clear |
| `add_test_section()` | `section()` or `begin_section()` | High | Shorter, more intuitive |
| `add_test_subsection()` | `subsection()` or `begin_subsection()` | High | Consistent with section |
| `end_test_section()` | `end_section()` or remove | Medium | Shorter, or eliminate if using blocks |
| `add_test()` | `test_case()` or `test()` (shorthand) | High | More accurate - registers Test Cases, not Tests |
| `run_all_tests()` | Keep as-is or `run()` | Low | Already clear, or shorter |

### 5. Supporting Full Hierarchy (Future Enhancement)

To fully support the hierarchy **Test Suite → Tests → Test Sections → Test Cases → Test Steps**, consider adding:

```unicon
# Add a Test (major grouping)
suite.add_test(name)                    # e.g., "JSON-RPC Tests"
   suite.section("Calculator Operations")  # Test Section
      suite.test_case("test_addition", test_add, "Test addition")  # Test Case
         # Test Steps are assertions within the test_case procedure
   suite.section("Error Handling")       # Another Test Section
      suite.test_case("test_errors", test_errors, "Test errors")

suite.add_test("LSP Message Tests")     # Another Test
   suite.section("Message Parsing")
      suite.test_case("test_parsing", test_parsing, "Test parsing")
```

This would require:
- `add_test(name)` - Register a Test (major grouping at the Test level)
- `add_test_section(name)` - Register a Test Section within a Test
- `add_test_case(name, test_proc, description)` - Register a Test Case within a Test Section
- Test Steps are implicit (assertions within Test Case procedures)

**Note**: The framework supports the full hierarchy. Tests can be explicitly registered using `add_test(name)`, and then Test Sections and Test Cases can be added within those Tests. The hierarchical numbering reflects this structure.

## Table of Contents

1. [Test Fixtures/Setup/Teardown](#1-test-fixturessetteardown)
2. [Test Filtering](#2-test-filtering)
3. [Better Assertion Helpers](#3-better-assertion-helpers)
4. [Test Discovery](#4-test-discovery)
5. [Parallel Test Execution](#5-parallel-test-execution)
6. [Test Output Capture](#6-test-output-capture)
7. [Test Timeouts](#7-test-timeouts)
8. [Better Error Reporting](#8-better-error-reporting)
9. [Test Result Export](#9-test-result-export)
10. [Conditional Test Execution](#10-conditional-test-execution)
11. [Test Coverage Integration](#11-test-coverage-integration)
12. [Parameterized Tests](#12-parameterized-tests)
13. [Mock/Stub Support](#13-mockstub-support)
14. [Performance Testing](#14-performance-testing)
15. [Better Debug Mode](#15-better-debug-mode)

---

## 1. Test Fixtures/Setup/Teardown

### Description
Add support for setup and teardown methods that run automatically before/after tests.

### Features
- `setup()` - Runs before each test
- `teardown()` - Runs after each test (even if test fails)
- `setup_suite()` - Runs once before all tests in suite
- `teardown_suite()` - Runs once after all tests in suite

### Implementation Approach
```unicon
class UniconTestSuite(...)
   method add_setup(setup_proc)
      self.setup_proc := setup_proc
   end
   
   method add_teardown(teardown_proc)
      self.teardown_proc := teardown_proc
   end
   
   method add_suite_setup(setup_proc)
      self.suite_setup_proc := setup_proc
   end
   
   method add_suite_teardown(teardown_proc)
      self.suite_teardown_proc := teardown_proc
   end
   
   # In run_all_tests():
   # Call suite_setup_proc once at start
   # Call setup_proc before each test
   # Call teardown_proc after each test
   # Call suite_teardown_proc once at end
end
```

### Use Cases
- Initialize test data before each test
- Clean up resources after tests
- Set up database connections once per suite
- Reset global state between tests

### Priority: High
### Complexity: Medium

---

## 2. Test Filtering

### Description
Allow running specific tests by name, pattern, or tag.

### Features
- Run tests matching a pattern: `suite.run_tests("test_*_math")`
- Run tests by tag: `suite.run_tests(tags := ["integration"])`
- Skip specific tests
- Exclude tests matching pattern

### Implementation Approach
```unicon
method run_all_tests(filter_pattern, exclude_pattern, tags)
   local test, test_name
   
   every test := !tests do {
      test_name := test[1]
      
      # Apply filters
      if \filter_pattern & not match(filter_pattern, test_name) then next
      if \exclude_pattern & match(exclude_pattern, test_name) then next
      if \tags & not has_tag(test, tags) then next
      
      # Run test...
   }
end

method add_test(name, test_proc, description, tags)
   # Store tags with test
   put(tests, [name, test_proc, description, hierarchical_num, section_path, section_name, tags])
end
```

### Use Cases
- Run only fast unit tests during development
- Run only integration tests before release
- Skip known broken tests temporarily
- Run tests matching a specific feature

### Priority: High
### Complexity: Low-Medium

---

## 3. Better Assertion Helpers

### Description
Expand the set of assertion helpers for common testing scenarios.

### New Assertions

#### `assert_contains(container, item, message)`
Check if item is in container (string, list, table, set).
```unicon
assert_contains("hello world", "world", "String should contain 'world'")
assert_contains([1, 2, 3], 2, "List should contain 2")
```

#### `assert_not_contains(container, item, message)`
Check if item is NOT in container.

#### `assert_matches(pattern, string, message)`
Check if string matches regex pattern.
```unicon
assert_matches("^[0-9]+$", "12345", "Should be all digits")
```

#### `assert_approx_equal(expected, actual, tolerance, message)`
Floating-point comparison with tolerance.
```unicon
assert_approx_equal(0.1 + 0.2, 0.3, 0.0001, "Floating point addition")
```

#### `assert_raises(procedure, expected_error, message)`
Verify that a procedure raises an error.
```unicon
assert_raises{divide_by_zero(), "division by zero", "Should raise error"}
```

#### `assert_deep_equal(expected, actual, message)`
Deep comparison for nested structures (tables, lists, records).
```unicon
assert_deep_equal([1, [2, 3], {"a": 4}], [1, [2, 3], {"a": 4}], "Nested structures")
```

#### `assert_type(value, expected_type, message)`
Check if value is of expected type.
```unicon
assert_type(42, "integer", "Should be integer")
```

### Implementation Approach
- Add procedures similar to existing `assert_equal`, `assert_not_null`, etc.
- Use `current_test_suite` global for context
- Implement deep comparison recursively
- For `assert_raises`, use `&error` or try-catch pattern

### Priority: High
### Complexity: Medium

---

## 4. Test Discovery

### Description
Automatically discover and load test procedures from files.

### Features
- Auto-discover procedures matching pattern (e.g., `test_*`)
- Load tests from multiple files
- Support for test classes
- Recursive directory scanning

### Implementation Approach
```unicon
procedure discover_tests(directory, pattern)
   local files, file, procs, proc_name
   files := []
   # Scan directory for .icn files
   every file := !files do {
      # Parse file and find procedures matching pattern
      # Return list of [file, procedure_name, procedure]
   }
end

method add_tests_from_file(filename, pattern)
   local tests_found
   tests_found := discover_tests(filename, pattern | "test_*")
   every put(self.tests, !tests_found)
end
```

### Use Cases
- Automatically find all tests in a directory
- No need to manually register each test
- Support for test organization across multiple files

### Priority: Medium
### Complexity: High (requires parsing Unicon source)

---

## 5. Parallel Test Execution

### Description
Run independent tests concurrently to speed up test execution.

### Features
- Run tests in parallel threads
- Thread-safe test execution
- Configurable parallelism level
- Dependency management (some tests must run sequentially)

### Implementation Approach
```unicon
method run_all_tests_parallel(max_threads)
   local test_queue, workers, results
   
   test_queue := mutex(list())
   every put(test_queue, !tests)
   
   workers := []
   every !max_threads do {
      put(workers, thread run_test_worker(test_queue))
   }
   
   every wait(!workers)
end

procedure run_test_worker(test_queue)
   local test
   while test := critical test_queue: get(test_queue) do {
      # Run test and collect results thread-safely
   }
end
```

### Considerations
- Tests must be independent (no shared mutable state)
- Need thread-safe result collection
- Setup/teardown must be thread-safe
- May need test isolation mechanisms

### Priority: Medium
### Complexity: High

---

## 6. Test Output Capture

### Description
Capture stdout/stderr during test execution for verification.

### Features
- Capture `write()` output during tests
- Capture `&errout` output
- Assert on captured output
- Option to suppress output during test run

### Implementation Approach
```unicon
class OutputCapture()
   field captured_stdout
   field captured_stderr
   
   method start()
      # Redirect stdout/stderr to buffers
   end
   
   method stop()
      # Restore stdout/stderr
   end
   
   method get_stdout()
      return self.captured_stdout
   end
end

procedure assert_output_contains(capture, expected, message)
   if not find(expected, capture.get_stdout()) then {
      write(&errout, "Expected output not found: ", expected)
      fail
   }
end
```

### Use Cases
- Test that procedures print correct messages
- Verify error messages
- Test command-line interfaces
- Suppress noisy output during test runs

### Priority: Medium
### Complexity: Medium-High (requires I/O redirection)

---

## 7. Test Timeouts

### Description
Set timeouts for individual tests to catch hanging tests.

### Features
- Per-test timeout configuration
- Default timeout for all tests
- Timeout exception handling
- Report slow tests

### Implementation Approach
```unicon
method add_test(name, test_proc, description, timeout)
   # Store timeout with test
   put(tests, [name, test_proc, description, ..., timeout])
end

method run_test_with_timeout(test, timeout_ms)
   local test_co, result, start_time
   
   test_co := create test[2]()
   start_time := microseconds()
   
   # Use alarm or thread with timeout
   if timeout := @test_co then {
      return timeout
   } else {
      # Test timed out
      write(&errout, "Test ", test[1], " timed out after ", timeout_ms, "ms")
      fail
   }
end
```

### Use Cases
- Catch infinite loops in tests
- Ensure tests complete in reasonable time
- Identify performance regressions
- Prevent CI/CD from hanging

### Priority: Medium
### Complexity: Medium (requires timeout mechanism)

---

## 8. Better Error Reporting

### Description
Improve error messages and debugging information on test failures.

### Features
- Stack traces on failures
- Diff output for failed assertions (show expected vs actual)
- Context information (file, line number, test name)
- Pretty-print complex data structures
- Highlight differences in output

### Implementation Approach
```unicon
procedure assert_equal(expected, actual, message)
   if expected ~== actual then {
      if \message then
         write(&errout, "Assertion failed: ", message)
      
      # Show diff for strings
      if type(expected) == "string" & type(actual) == "string" then {
         write(&errout, "  Expected: ", expected)
         write(&errout, "  Actual:   ", actual)
         write(&errout, "  Diff:     ", highlight_diff(expected, actual))
      } else {
         # Pretty print for complex structures
         write(&errout, "  Expected: ", pretty_print(expected))
         write(&errout, "  Actual:   ", pretty_print(actual))
      }
      
      # Show stack trace if available
      if \current_test_suite.verbose_mode then {
         print_stack_trace()
      }
      
      fail
   }
end
```

### Use Cases
- Faster debugging of test failures
- Better understanding of what went wrong
- Easier identification of assertion mismatches

### Priority: High
### Complexity: Medium

---

## 9. Test Result Export

### Description
Export test results to various formats for CI/CD integration.

### Features
- JUnit XML format (for Jenkins, etc.)
- JSON format
- HTML reports
- CSV export
- Configurable output location

### Implementation Approach
```unicon
method export_results(format, filename)
   case format of {
      "junit" : export_junit_xml(filename)
      "json"  : export_json(filename)
      "html"  : export_html_report(filename)
      "csv"   : export_csv(filename)
   }
end

procedure export_junit_xml(filename)
   local file
   file := open(filename, "w")
   write(file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
   write(file, "<testsuites>")
   # Write test results in JUnit format
   write(file, "</testsuites>")
   close(file)
end
```

### Use Cases
- CI/CD integration (Jenkins, GitHub Actions, etc.)
- Test reporting dashboards
- Historical test result tracking
- Sharing test results with team

### Priority: Medium
### Complexity: Low-Medium

---

## 10. Conditional Test Execution

### Description
Run tests only when certain conditions are met.

### Features
- Skip tests based on conditions (OS, features, environment)
- Mark tests as expected failures
- Run tests only on specific platforms
- Conditional test registration

### Implementation Approach
```unicon
method add_test(name, test_proc, description, condition)
   if \condition & not condition() then {
      # Skip this test
      self.skipped_count +:= 1
      return
   end
   # Add test normally
end

procedure skip_if(condition, reason)
   if condition then {
      write(&errout, "Test skipped: ", reason)
      fail  # Use fail to indicate skip (Unicon semantics)
   }
end

method add_test(name, test_proc, description, expected_failure)
   # Mark test as expected to fail
   put(tests, [name, test_proc, description, ..., expected_failure])
end
```

### Use Cases
- Skip tests on unsupported platforms
- Skip tests when features unavailable
- Mark known issues as expected failures
- Platform-specific test suites

### Priority: Medium
### Complexity: Low

---

## 11. Test Coverage Integration

### Description
Track which code paths are executed during tests.

### Features
- Line coverage reporting
- Branch coverage
- Function coverage
- Coverage reports (HTML, text)
- Coverage thresholds

### Implementation Approach
```unicon
# Requires instrumentation of source code
# Could use Unicon's built-in profiling or custom instrumentation

method enable_coverage()
   self.coverage_enabled := 1
   # Enable code instrumentation
end

method get_coverage_report()
   # Collect coverage data
   # Generate report
end
```

### Considerations
- Requires source code instrumentation
- May need integration with Unicon compiler
- Performance impact
- Complex to implement

### Priority: Low
### Complexity: Very High

---

## 12. Parameterized Tests

### Description
Run the same test with different input parameters.

### Features
- Data-driven testing
- Test with multiple inputs
- Table-driven tests
- Reduce test code duplication

### Implementation Approach
```unicon
method add_parameterized_test(name, test_proc, test_data, description)
   local params
   every params := !test_data do {
      # Create wrapper procedure that calls test_proc with params
      wrapper := create test_with_params(test_proc, params)
      suite.add_test(name || "_" || string(params), wrapper, description)
   }
end

procedure test_with_params(test_proc, params)
   return @(create test_proc(params))
end

# Usage:
suite.add_parameterized_test("test_addition", test_add, 
   [[2, 3, 5], [10, 20, 30], [0, 0, 0]], 
   "Test addition with various inputs")
```

### Use Cases
- Test same logic with many inputs
- Reduce test code duplication
- Comprehensive input validation
- Boundary value testing

### Priority: Medium
### Complexity: Medium

---

## 13. Mock/Stub Support

### Description
Create mock objects and stubs for testing dependencies.

### Features
- Mock objects with configurable behavior
- Stub procedures/functions
- Verify mock interactions
- Mock expectations

### Implementation Approach
```unicon
class MockObject()
   field expectations
   field calls
   
   method expect(method_name, args, return_value)
      # Record expectation
   end
   
   method verify()
      # Check all expectations met
   end
end

procedure create_mock(class_name)
   # Create mock instance
   return MockObject()
end

procedure stub_procedure(proc_name, replacement)
   # Replace procedure with stub (requires dynamic loading)
end
```

### Considerations
- Unicon's static nature makes this challenging
- May require code generation or dynamic loading
- Complex to implement properly

### Priority: Low
### Complexity: Very High

---

## 14. Performance Testing

### Description
Benchmark tests and detect performance regressions.

### Features
- Benchmark mode for timing tests
- Performance regression detection
- Statistical analysis of timing
- Compare performance across runs

### Implementation Approach
```unicon
method add_benchmark(name, benchmark_proc, description)
   # Mark test as benchmark
   put(benchmarks, [name, benchmark_proc, description])
end

method run_benchmarks(iterations)
   local benchmark, times, stats
   every benchmark := !benchmarks do {
      times := []
      every !iterations do {
         put(times, time_execution(benchmark[2]))
      }
      stats := calculate_stats(times)
      report_benchmark(benchmark[1], stats)
   }
end

method detect_regression(baseline_file, threshold)
   # Load baseline performance data
   # Compare test run to baseline
   # Report regressions exceeding threshold
end
```

### Use Cases
- Performance regression testing
- Benchmark critical code paths
- Monitor performance over time
- Identify performance bottlenecks

### Priority: Low
### Complexity: Medium

---

## 15. Better Debug Mode

### Description
Enhanced debugging capabilities for test failures.

### Features
- Interactive debugging on failure
- Step-through test execution
- Breakpoints in tests
- Inspect variables at failure point
- REPL integration

### Implementation Approach
```unicon
method set_debug_mode(enable)
   self.debug_mode := enable
end

method run_test_with_debug(test)
   if self.debug_mode then {
      write("Debug mode: Running test ", test[1])
      write("Press Enter to continue, 's' to step, 'q' to quit")
      # Interactive debugging
   } else {
      # Normal execution
   }
end
```

### Considerations
- Requires interactive input
- May need integration with Unicon debugger
- Complex user interface

### Priority: Low
### Complexity: High

---

## Implementation Priority Summary

### High Priority (Implement First)
1. **Test Fixtures/Setup/Teardown** - Essential for test organization
2. **Test Filtering** - Very useful for development workflow
3. **Better Assertion Helpers** - Improves test writing experience
4. **Better Error Reporting** - Critical for debugging

### Medium Priority (Implement Next)
5. **Test Output Capture** - Useful for testing I/O
6. **Test Timeouts** - Important for CI/CD
7. **Test Result Export** - Needed for integration
8. **Conditional Test Execution** - Useful for cross-platform
9. **Parameterized Tests** - Reduces code duplication

### Low Priority (Future Features)
10. **Test Discovery** - Nice to have, but manual registration works
11. **Parallel Test Execution** - Performance optimization
12. **Test Coverage Integration** - Advanced feature
13. **Mock/Stub Support** - Complex, may not be feasible
14. **Performance Testing** - Specialized use case
15. **Better Debug Mode** - Nice to have, but not essential

---

## Notes

- Some features may require Unicon language features not currently available
- Test framework should remain simple and easy to use
- Prioritize features that provide the most value for common use cases
- Document all new features thoroughly

---

## Version History

- **2025-11-XX**: Initial framework documentation created (framework developed from scratch)

