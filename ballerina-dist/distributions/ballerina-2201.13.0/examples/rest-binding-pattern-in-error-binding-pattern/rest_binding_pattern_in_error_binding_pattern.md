# Rest binding pattern in error binding pattern

You can use the rest binding pattern (`...r`) to bind the detail mappings that are not explicitly bound in the error binding pattern. The type of the rest binding will be a `map` holding the fields that have not been matched.

::: code rest_binding_pattern_in_error_binding_pattern.bal :::

::: out rest_binding_pattern_in_error_binding_pattern.out :::

## Related links
- [Binding Patterns](/learn/by-example/binding-patterns/)
- [Typed Binding Pattern](/learn/by-example/typed-binding-pattern/)
- [Error Binding Pattern](/learn/by-example/error-binding-pattern/)
