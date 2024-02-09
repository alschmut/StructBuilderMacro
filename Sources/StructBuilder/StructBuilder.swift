// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a peer struct which implements the builder pattern
///
///     @Buildable
///     struct Person {
///         let name: String
///         let age: Int
///         let address: Address
///         let favouriteSeason: Season
///     }
///
///     @Buildable
///     enum Season {
///         case .winter
///         case .spring
///         case .summer
///         case .autumn
///     }
///
///  will expand to
///
///     struct PersonBuilder {
///         var name: String = ""
///         var age: Int = 0
///         var address: Address = AddressBuilder().build()
///         var favouriteSeason: SeasonBuilder = SeasonBuilder().build()
///
///         func build() -> Person {
///             return Person(
///                 name: name,
///                 age: age,
///                 address: address,
///                 favouriteSeason: favouriteSeason
///             )
///         }
///     }
///
///     struct SeasonBuilder {
///         var value: Season = .spring
///
///         func build() -> Season {
///             return value
///         }
///     }
@attached(peer, names: suffixed(Builder))
public macro Buildable() = #externalMacro(
    module: "StructBuilderMacro",
    type: "BuildableMacro"
)
