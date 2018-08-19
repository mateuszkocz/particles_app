module Main exposing (..)

import Element exposing (Element, decodeElements)
import Html exposing (Html, button, div, h1, img, p, text, ul, li)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (field, Decoder)


---- FLAGS ----


type alias Flags =
    { apiPath : String
    }



---- MODEL ----


type alias ApiPath =
    String


type alias Model =
    { apiPath : ApiPath
    , elements : List Element
    , fetchingElements : Bool
    , elementsFetchErrorMessage : Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { apiPath = flags.apiPath
      , elements = []
      , fetchingElements = False
      , elementsFetchErrorMessage = Maybe.Nothing
      }
    , Cmd.batch [ getElements flags.apiPath ]
    )



---- UPDATE ----


type Msg
    = NoOp
    | FetchElements
    | ElementsResult (Result Http.Error (List Element))


getElements : ApiPath -> Cmd Msg
getElements apiPath =
    Http.get (constructEndpoint apiPath "/elements") (decodeResponseWith decodeElements)
        |> Http.send ElementsResult


decodeResponseWith : Decoder a -> Decoder a
decodeResponseWith decoder =
    field "data" decoder


constructEndpoint : String -> String -> String
constructEndpoint apiPath entityPath =
    "http://" ++ apiPath ++ "/api" ++ entityPath


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FetchElements ->
            ( { model | fetchingElements = True }, getElements model.apiPath )

        ElementsResult (Ok elements) ->
            ( { model
                | elements = elements
                , fetchingElements = False
                , elementsFetchErrorMessage = Maybe.Nothing
              }
            , Cmd.none
            )

        ElementsResult (Err err) ->
            ( { model | elementsFetchErrorMessage = Just (toString err), fetchingElements = False }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ if model.fetchingElements then
            p [] [ text "Fetching…" ]
          else
            (text "")
        , button [ onClick FetchElements ] [ text "get element" ]
        , ul [] (List.map (\element -> li [] [ text "Element" ]) model.elements)
        , case model.elementsFetchErrorMessage of
            Just err ->
                p [] [ text err ]

            Nothing ->
                text ""
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
