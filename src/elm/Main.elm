module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (id)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { placeHolderValue : String
    }


init : Model
init =
    { placeHolderValue = ""
    }



-- UPDATE


type Msg
    = DoNothing


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model



-- VIEW


view : Model -> Html msg
view model =
    div [ id "root" ] []
