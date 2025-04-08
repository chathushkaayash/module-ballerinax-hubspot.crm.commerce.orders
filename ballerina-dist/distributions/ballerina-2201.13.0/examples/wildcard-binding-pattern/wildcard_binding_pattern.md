# Wildcard binding pattern

A wildcard binding pattern which is denoted by the `_` symbol, matches a value if the value belongs to type `any`. As long as the basic type of the value is not an `error`, it does not cause any assignment to be made to the variable. It is useful for ignoring values such as the return value of a function or values in a list.

::: code wildcard_binding_pattern.bal :::

::: out wildcard_binding_pattern.out :::

## Related links
- [Binding patterns](/learn/by-example/binding-patterns/)