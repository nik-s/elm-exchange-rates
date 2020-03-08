module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json


type Model
    = Failure
    | Loading
    | Success String


type Msg
    = GotRates (Result Http.Error String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://api.exchangeratesapi.io/latest"
        , expect = Http.expectString GotRates
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotRates result ->
            case result of
                Ok rates ->
                    ( Success rates, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Exchange rates" ]
        , case model of
            Loading ->
                p [] [ text "Loading…" ]

            Failure ->
                p [] [ text "Something went wrong…" ]

            Success rates ->
                pre [] [ text rates ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
