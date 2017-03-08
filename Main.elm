module Main exposing (..)

import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Char
import String
import Dict exposing (Dict)


main : Program Never
main =
    beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { rainbow : List ( Char, String )
    , highlightedIndex : Int
    , resetDropdown : Bool
    }


init : Model
init =
    { rainbow =
        [ ( 'R', "???" )
        , ( 'O', "???" )
        , ( 'Y', "???" )
        , ( 'G', "???" )
        , ( 'B', "???" )
        , ( 'I', "???" )
        , ( 'V', "???" )
        ]
    , highlightedIndex = 0
    , resetDropdown = True
    }


rainbowColors : Dict String String
rainbowColors =
    Dict.fromList
        [ ( "red", "#cc0000" )
        , ( "orange", "#f57900" )
        , ( "yellow", "#edd400" )
        , ( "green", "#73d216" )
        , ( "blue", "#3B43D1" )
        , ( "indigo", "#A90AD1" )
        , ( "violet", "#540F66" )
        ]


type Msg
    = ChangeColor String
    | Next
    | Prev



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeColor newColor ->
            let
                updateAtIndex index ( letter, color ) =
                    ( letter
                    , if index == model.highlightedIndex then
                        newColor
                      else
                        color
                    )
            in
                { model
                    | rainbow = List.indexedMap updateAtIndex model.rainbow
                    , resetDropdown = False
                }

        Next ->
            { model
                | highlightedIndex = model.highlightedIndex + 1
                , resetDropdown = True
            }

        Prev ->
            { model
                | highlightedIndex = model.highlightedIndex - 1
                , resetDropdown = True
            }



-- View


view : Model -> Html Msg
view model =
    div []
        [ h1 [ row ] [ text "Rainbow!" ]
        , div [ row ] <| List.indexedMap (colorTile model.highlightedIndex) model.rainbow
        , div [ row ]
            [ button [ buttonStyles, onClick Prev ] [ text "Left" ]
            , colorSelector model.resetDropdown
            , button [ buttonStyles, onClick Next ] [ text "Right" ]
            ]
        ]


colorTile : Int -> Int -> ( Char, String ) -> Html Msg
colorTile highlightedIndex index ( letter, color ) =
    let
        getColor color =
            Dict.get color rainbowColors
                |> Maybe.withDefault "#ffffff"
    in
        div
            [ colorStyles <|
                ( "background", getColor color )
                    :: if index == highlightedIndex then
                        [ ( "border", "7px solid orange" ) ]
                       else
                        []
            ]
            [ text <| String.fromChar <| Char.toUpper letter ]


colorSelector : Bool -> Html Msg
colorSelector resetDropdown =
    Dict.keys rainbowColors
        |> List.map (\k -> option [ value k ] [ text <| "Turn " ++ k ])
        |> (::) (option [ value "", selected resetDropdown ] [ text <| "Change color..." ])
        |> select [ onInput ChangeColor, selectStyles ]


colorStyles : List ( String, String ) -> Html.Attribute a
colorStyles extraStyles =
    style <|
        [ ( "padding", "30px 20px" )
        , ( "width", "100px" )
        , ( "margin", "10px" )
        , ( "display", "inline-block" )
        , ( "border", "3px solid #222" )
        , ( "border-radius", "20px" )
        , ( "color", "#222" )
        , ( "font-family", "Helvetica" )
        , ( "font-size", "60px" )
        , ( "text-align", "center" )
        ]
            ++ extraStyles


buttonStyles : Html.Attribute a
buttonStyles =
    style
        [ ( "padding", "10px 20px" )
        , ( "margin", "10px 30px" )
        , ( "border", "1px solid #222" )
        , ( "color", "#222" )
        , ( "font-family", "Helvetica" )
        , ( "font-size", "30px" )
        , ( "text-align", "center" )
        ]


selectStyles : Html.Attribute a
selectStyles =
    style
        [ ( "padding", "10px 20px" )
        , ( "margin", "10px 30px" )
        , ( "border", "1px solid #222" )
        , ( "color", "#222" )
        , ( "font-family", "Helvetica" )
        , ( "font-size", "30px" )
        , ( "text-align", "center" )
        ]


row : Html.Attribute a
row =
    style
        [ ( "text-align", "center" )
        , ( "margin", "50px" )
        ]
