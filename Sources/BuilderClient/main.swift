import Builder


@CustomBuilder
struct House {
    let name: String
    var familyName: String = ""
}

@CustomBuilder
struct Car {
    let numberOfRooms: String
}
