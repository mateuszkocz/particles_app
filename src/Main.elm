module Main exposing (..)

import Html exposing (Html, text, div, h1, img, p)
import Html.Attributes exposing (src)


---- FLAGS ----


type alias Flags =
    { apiPath : String
    }



---- MODEL ----


type alias Model =
    { apiPath : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { apiPath = flags.apiPath }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , p [] [ text model.apiPath ]
        ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
