
@attached(extension, names: arbitrary)
public macro PropertyNameAccessible() = #externalMacro(
    module: "Implementation",
    type: "PropertyNameMacro"
)
