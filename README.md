# Swift Struct Builder Macro
An attached swift macro that produces a peer struct which implements the builder pattern.
This allows the creation of the struct with minimal effort using default values.

> **Important!** This macro is intended to be used for simple structs without explicit initialiser.
The macro is by no means a perfect solution that works for all struct implementations.
The macro makes a best guess to decide how the implicit memberwise initialiser could look like and might fail if some edge cases have not been considered.
The macro was created out of personal interest and for a few smaller private projects.

### Example
```swift
@Buildable
struct Person {
    let name: String
    let age: Int
    let address: Address
    let hobby: String?
    
    var likesReading: Bool {
        hobby == "Reading" 
    }
    
    static let minimumAge = 21
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

### Limitations
- The list of default values is limited to the values specified in the below table. The list can be extended, if necessary.
- For an enum Type `MyEnum` the default value is currently set to `MyEnumBuilder().build()`, instead to the first enum case
- The macro only works on `struct` definitions


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
| [AnyType:AnyType] | [:] |
| AnyType? | *(implicitly nil)* |
| AnyType! | *(implicitly nil)* |
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


### Roadmap

Why did I create the macro? 
- I created the macro out of personal curiosity and the hope to be able to reduce repetitive code in my own projects
- I am not using the macro in any real project yet, mostly because I don't know yet how to get the first enum case when the type is en enum. If anybody knows how, please reach out :)

Will I continue developing the macro?
- Depending on my own use cases, which I am/was trying to solve, I might continue developing the macro, **though, I do guarantee to keep the project up to date**

Why did I publish the macro publicly?
- In case other developers find the macro useful and want to use it as is
- In case other developers want to improve the macro by making changes to my project or forking it
