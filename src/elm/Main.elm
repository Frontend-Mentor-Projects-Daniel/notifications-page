module Main exposing (..)

import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Attributes.Aria exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Svg.Styled.Attributes exposing (textAnchor)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view >> Html.Styled.toUnstyled }



-- MODEL


type alias Model =
    { hasRead : Bool
    , unReadMessages : Int
    , isPrivateMessage : Bool
    , isComment : Bool
    , notifications : Int
    }


init : Model
init =
    { hasRead = True
    , unReadMessages = 0
    , isPrivateMessage = False
    , isComment = False
    , notifications = 0
    }



-- UPDATE


type Msg
    = DoNothing
    | DoSomething


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model

        DoSomething ->
            model



-- VIEW


view : Model -> Html msg
view model =
    div [ id "root", css rootComponent ]
        [ header [ css headerComponent, class "center flex-gap-9px" ]
            [ h1 [ css notifications ] [ text "Notifications" ]
            , span [ css notificationsNumber, role "status", ariaLive "polite" ] [ text "3" ]
            , button [ css markAsReadBtn ] [ text "Mark all as read" ]
            ]
        , main_ [ class "center" ] []
        , footer [ class "attribution center", css footerComponent ]
            [ text "Challenge by"
            , a [ href "https://www.frontendmentor.io?ref=challenge", Html.Styled.Attributes.target "_blank" ] [ text " Frontend Mentor. " ]
            , text "Coded by "
            , a [ href "#" ] [ text "Daniel Arzanipour" ]
            ]
        ]



-- CSS
-- template : CssRule
-- template =
--     let
--         props =
--             [ { val = }
--             ]
--     in
--     createCss props


type alias CssRule =
    List Style


createCss : List { a | val : b } -> List b
createCss styles =
    List.map (\prop -> prop.val) styles


pxToRem : Float -> Float
pxToRem px =
    px / 16



-- ROOT COMPONENT


rootComponent : CssRule
rootComponent =
    let
        props =
            [ { val = displayFlex }
            , { val = flexDirection column }
            ]
    in
    createCss props



-- HEADER COMPONENT


headerComponent : CssRule
headerComponent =
    let
        props =
            [ { val = displayFlex }
            , { val = padding2 (px 0) (px 16) }
            ]
    in
    createCss props


notifications : CssRule
notifications =
    let
        props =
            [ { val = fontSize (rem (pxToRem 20)) }
            ]
    in
    createCss props


notificationsNumber : CssRule
notificationsNumber =
    let
        props =
            [ { val = color (hex "#FFFFFF") }
            , { val = backgroundColor (hex "#0A327B") }
            , { val = fontSize (rem (pxToRem 16)) }
            , { val = fontWeight (int 800) }
            , { val = padding4 (px 4) (px 11) (px 4) (px 11) }
            , { val = borderRadius (px 6) }
            ]
    in
    createCss props


markAsReadBtn : CssRule
markAsReadBtn =
    let
        props =
            [ { val = color (hex "#5E6778") }
            , { val = backgroundColor transparent }
            , { val = border zero }
            , { val = cursor pointer }
            , { val = marginInlineStart auto }
            ]
    in
    createCss props



-- MAIN COMPONENT
-- mainComponent : CssRule
-- mainComponent =
--     let
--         props =
--             [ { val = }
--             ]
--     in
--     createCss props
-- FOOTER COMPONENT


footerComponent : CssRule
footerComponent =
    let
        props =
            [ { val = marginBlockStart auto }
            ]
    in
    createCss props
