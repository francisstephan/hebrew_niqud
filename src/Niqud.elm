port module Niqud exposing (main)

import Browser
import Html exposing (Html, Attribute, div, input, text, button, br, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Trans

-- MAIN
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

-- MODEL

type alias Model =
  { content : String
  }

type alias Flags = {} -- do not need flags

init : Flags -> ( Model, Cmd msg )
init _ =
  ( {content = "" }, Cmd.none)

-- UPDATE

type Msg
  = Change String | Reset | CopyToClipboard

port copyToClip : String -> Cmd msg
port resetFocus : String -> Cmd msg

update : Msg -> { content : String } -> ( { content : String }, Cmd Msg )
update msg model =
  case msg of
    Change newContent ->
      ({ model | content = newContent }, Cmd.none)
    Reset ->
      ({model | content = ""}, resetFocus "" )
    CopyToClipboard ->
      ( model, copyToClip "convert")

-- SUBSCRIPTIONS

subscriptions :  { content : String } -> Sub Msg
subscriptions _ = Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ span [style "font-weight" "bold"] [ text "Entrez des caractères latins :"]
    , button [ class "rebut", onClick Reset ] [ text "Remise à zéro" ]
    , button [ class "rebut", onClick CopyToClipboard ] [ text "   Copier   " ]
    , br [] []
    , input [ autofocus True, size 120, placeholder "Caractères latins", value model.content, onInput Change, id "entree" ] []
    , div [style "font-weight" "bold", style "margin-top" "12px"] [ text "Texte hébreu avec voyelles :"]
    , div [ id "convert", dir "rtl"] [ text (Trans.transl model.content) ]
    ]
