# Expression equality

Expression equality is determined using two operators: `==` for value equality and `===` for reference equality. The `==` operator checks for deep equality between two values by comparing the actual data. In contrast, the `===` operator checks whether two values share the same storage identity, meaning it checks if the values reference the same memory location. 

Values with storage identity, such as structured types like maps and arrays, have an identity that comes from the location where the value is stored. For such values, the `===` check determines if two references point to the same location. For simple types such as integers and booleans, which do not have storage identity, `===` behaves the same as `==` except for floating point values.

::: code expression_equality.bal :::

::: out expression_equality.out :::

## Related links
- [Maps](/learn/by-example/maps)
