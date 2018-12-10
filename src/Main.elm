module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser as Parser exposing ((</>))



---- MODEL ----


type alias Model =
    { key : Navigation.Key }


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChange Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChange url ->
            ( model, Cmd.none )



---- PARSER ----


type Route
    = Top
    | Profile
    | NotFound


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map Profile <| Parser.s "profile"
        ]



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "title"
    , body =
        [ viewHeader
        , a
            [ href "https://google.com"
            , target "__blank"
            ]
            [ text "Go to Google.com" ]
        ]
    }


viewHeader : Html Msg
viewHeader =
    header []
        [ h1 [] [ text "Todo List" ] ]



---- PROGRAM ----


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChange
        }
