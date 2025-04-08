# `typedesc` Type

The `typedesc` type is a built-in type that represents a type descriptor and is immutable (a subtype of read-only). It has a type parameter that describes the types that are described by the type descriptors that belong to that type descriptor. A `typedesc` value belongs to the `typedesc<T>` type if the type descriptor describes a type that is a subtype of `T`.

::: code typedesc_type.bal :::

::: out typedesc_type.out :::
