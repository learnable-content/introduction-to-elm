module Main exposing (..)

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    div []
        [ div [] [ button [ onClick Increment ] [ text "+1" ] ]
        , div [] [ text <| toString model ]
        , div [] [ button [ onClick Decrement ] [ text "-1" ] ]
        ]


main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
