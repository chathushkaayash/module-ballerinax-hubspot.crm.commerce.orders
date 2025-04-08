import ballerina/io;
 
// Module-level function definition.
function isEven(int n) returns boolean {
   return n % 2 == 0;
}
 
public function main() {
   // The `isEven` function is referred as a value.
   function (int n) returns boolean f = isEven;

   // The function values can be executed like regular function calls.
   io:println(f(5));
   io:println(f(6));
}
