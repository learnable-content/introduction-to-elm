module Main exposing (..)

import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Char
import String
import Dict exposing (Dict)
import List.Zipper as Zipper exposing (Zipper)


main : Program Never
main =
    beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { rainbow : Zipper ( Char, String )
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
            |> Zipper.fromList
            |> Zipper.withDefault ( '?', "?" )
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
                changeColor ( letter, color ) =
                    ( letter, newColor )
            in
                { model
                    | rainbow = Zipper.update changeColor model.rainbow
                    , resetDropdown = False
                }

        Next ->
            { model
                | rainbow = Zipper.next model.rainbow |> Maybe.withDefault model.rainbow
                , resetDropdown = True
            }

        Prev ->
            { model
                | rainbow = Zipper.previous model.rainbow |> Maybe.withDefault model.rainbow
                , resetDropdown = True
            }



-- View


view : Model -> Html Msg
view model =
    div []
        [ h1 [ row ] [ text "Rainbow!" ]
        , div [ row ] <|
            (Zipper.before model.rainbow |> List.map (colorTile False))
                ++ [ Zipper.current model.rainbow |> colorTile True ]
                ++ (Zipper.after model.rainbow |> List.map (colorTile False))
        , div [ row ]
            [ button [ buttonStyles, onClick Prev ] [ text "Left" ]
            , colorSelector model.resetDropdown
            , button [ buttonStyles, onClick Next ] [ text "Right" ]
            ]
        ]


colorTile : Bool -> ( Char, String ) -> Html Msg
colorTile highlighted ( letter, color ) =
    let
        getColor color =
            Dict.get color rainbowColors
                |> Maybe.withDefault "#ffffff"
    in
        div
            [ colorStyles <|
                ( "background", getColor color )
                    :: if highlighted then
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
