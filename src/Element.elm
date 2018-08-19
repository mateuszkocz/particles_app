module Element exposing (..)

import Json.Decode exposing (list, int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


type alias Element =
    { id : Int
    , name : String
    , symbol : String
    , atomicNumber : Int
    , group : Maybe Int
    , period : Int
    }


decodeElements : Decoder (List Element)
decodeElements =
    list decodeElement


decodeElement : Decoder Element
decodeElement =
    decode Element
        |> required "id" int
        |> required "name" string
        |> required "symbol" string
        |> required "atomic_number" int
        |> optional "group" (nullable int) Maybe.Nothing
        |> required "period" int
