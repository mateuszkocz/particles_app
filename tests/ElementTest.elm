module ElementTest exposing (..)

import Element exposing (Element, decodeElement, decodeElements)
import Test exposing (..)
import Expect
import Json.Decode exposing (decodeString)


elementDecoder : Test
elementDecoder =
    describe "Element decoder"
        [ test "Decode a single element" <|
            \_ ->
                let
                    result =
                        decodeString decodeElement
                            """
                            {
                                "id": 10,
                                "name": "Carbon",
                                "symbol": "C",
                                "atomic_number": 6,
                                "group": 14,
                                "period": 2
                            }
                            """
                in
                    case result of
                        Ok element ->
                            Expect.equal element (Element 10 "Carbon" "C" 6 (Just 14) 2)

                        Err err ->
                            Expect.fail err
        , test "Decodes an element without a group" <|
            \_ ->
                let
                    result =
                        decodeString decodeElement
                            """
                            {
                                "id": 2,
                                "name": "Berkelium",
                                "symbol": "Bk",
                                "atomic_number": 97,
                                "period": 7
                            }
                            """
                in
                    case result of
                        Ok element ->
                            Expect.equal element (Element 2 "Berkelium" "Bk" 97 Maybe.Nothing 7)

                        Err err ->
                            Expect.fail err
        , test "Decode a list of elements" <|
            \_ ->
                let
                    result =
                        decodeString decodeElements
                            """
                            [{
                                "id": 1,
                                "name": "Molybdenum",
                                "symbol": "Mo",
                                "atomic_number": 42,
                                "group": 6,
                                "period": 5
                            }, {
                                "id": 2,
                                "name": "Europium",
                                "symbol": "Eu",
                                "atomic_number": 63,
                                "period": 6
                            }]
                            """
                in
                    case result of
                        Ok list ->
                            Expect.equal list
                                [ (Element 1 "Molybdenum" "Mo" 42 (Just 6) 5)
                                , (Element 2 "Europium" "Eu" 63 Maybe.Nothing 6)
                                ]

                        Err err ->
                            Expect.fail err
        ]
