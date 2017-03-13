module Main exposing (..)

import Html


ourText : Maybe String
ourText =
    Just "hello world"


main =
    case ourText of
        Just string ->
            Html.text string

        Nothing ->
            Html.text "nothing here"
