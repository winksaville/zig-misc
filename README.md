# testExpected

Test if two slices are equal. If not print the contents of the
expected and actual strings to either stderr or a OutStream and
return false.

## Test
```
$ zig test index.zig 
Test 1/3 misc...OK
Test 2/3 testExpectedError...OK
Test 3/3 testExpected...OK
All tests passed.
```
