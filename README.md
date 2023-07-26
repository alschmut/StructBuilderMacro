# StructBuilderMacro
An attached macro that produces a peer struct which implements the builder pattern
This allows the creation of the struct with minimal effort using default values.

### Example
```swift
@Buildable
struct Person {
    let name: String
    let age: Int
    let address: Address
    let hobby: String?
}

let anyPerson = PersonBuilder().build()
let max = PersonBuilder(name: "Max").build()
```
Expanded macro
```swift
struct PersonBuilder {
    var name: String = ""
    var age: Int = 0
    var address: Address = AddressBuilder().build()
    var hobby: String?

    func build() -> Person {
        return Person(
            name: name,
            age: age,
            address: address,
            hobby: hobby
        )
    }
}
```


### Specified default values
The list of default values is limited to the values specified in the below table. 
If a type e.x. `UnknownType` is not part of the list, the macro will set the default value to `UnknownTypeBuilder().build()`, 
assuming that the `UnknownTypeBuilder` was created somewhere else.

| Type | Default Value |
| - | - |
| UnknownType | UnknownTypeBuilder().build() |
| String | "" |
| Int | 0 |
| Bool | false |
| Double | 0 |
| Float | 0 |
| Date | Date() |
| UUID | UUID() |
| [AnyType] | [] |
| AnyType? | *(implicitly nil)* |
| Int8 | 0 |
| Int16 | 0 |
| Int32 | 0 |
| Int46 | 0 |
| UInt | 0 |
| UInt8 | 0 |
| UInt16 | 0 |
| UInt32 | 0 |
| UInt46 | 0 |
| Data | Data() |
| URL | URL(string: "https://www.google.com")! |
| CGFloat | 0 |
| CGPoint | CGPoint() |
| CGRect | CGRect() |
| CGSize | CGSize() |
| CGVector | CGVector() |


### Limitations
- The list of default values is limited to the values specified in the above table. List can be extended, if necessary.
- For an enum Type `MyEnum` the default value is currently set to `MyEnumBuilder().build()`, instead to the first enum case
- The macro only works on `struct`'s
- Using implicitly unwrapped optionals on a property is currently not supported
- The buildable struct can not contain any static variables, because they are currently handled like non static variables
