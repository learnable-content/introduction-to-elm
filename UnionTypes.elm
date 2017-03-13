module UnionTypes exposing (..)


type Shape
    = Rectangle Float Float
    | Circle Float


area : Shape -> Float
area shape =
    case shape of
        Rectangle width height ->
            width * height

        Circle radius ->
            3.14 * (radius * radius)
