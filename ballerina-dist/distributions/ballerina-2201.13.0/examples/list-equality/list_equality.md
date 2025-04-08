# List equality

You can use `==` and `!=` on lists to check the deep equality of two lists: two lists are deep equal if they have the same members in the same order. Deep equality only works for `anydata` lists. `===` and `!==` check for the exact equality, which matches the references of the lists.

::: code list_equality.bal :::

::: out list_equality.out :::

## Related links
- [Tuples](/learn/by-example/tuples)
- [Arrays](/learn/by-example/arrays)
- [Expression equality](/learn/by-example/expression-equality)
- [List sub typing](/learn/by-example/list-subtyping)
