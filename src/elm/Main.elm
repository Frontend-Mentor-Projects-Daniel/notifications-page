module Main exposing (..)

-- import Css exposing (..)
-- import Css.Global exposing (media)
-- import Css.Media
-- import Html.Styled exposing (..)
-- import Html.Styled.Attributes exposing (..)
-- import Html.Styled.Attributes.Aria exposing (..)
-- import Html.Styled.Events exposing (onClick, onInput, onSubmit)
-- import Svg.Styled.Attributes exposing (textAnchor)

import Browser
import Html exposing (..)
import Html.Attributes exposing (alt, class, datetime, href, id, src)
import Html.Attributes.Aria exposing (ariaDescribedby, ariaLive, role)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- Browser.sandbox { init = init, update = update, view = view >> Html.Styled.toUnstyled }
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
    , unReadMessages = 5
    , isPrivateMessage = False
    , isComment = False
    , notifications = 0
    }



-- UPDATE


type Msg
    = MarkAllAsRead


update : Msg -> Model -> Model
update msg model =
    case msg of
        MarkAllAsRead ->
            { model | unReadMessages = 0 }



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "root" ]
        [ header [ class "header center" ]
            [ h1 [] [ text "Notifications" ]
            , span [ role "status", ariaLive "polite" ]
                [ text (String.fromInt model.unReadMessages)
                , span [ class "sr-only" ] [ text " new notifications" ]
                ]
            , button [ onClick MarkAllAsRead ] [ text "Mark all as read" ]
            ]
        , main_ [ class "main center stack" ]
            [ cardReactionTemplate tempData

            -- , div [ class "card private-message" ] []
            -- , div [ class "card comment" ] []
            ]
        , footer [ class "footer attribution center" ]
            [ text "Challenge by"
            , a [ href "https://www.frontendmentor.io?ref=challenge", Html.Attributes.target "_blank" ] [ text " Frontend Mentor. " ]
            , text "Coded by "
            , a [ href "#" ] [ text "Daniel Arzanipour" ]
            ]
        ]



-- FUNCTIONS
-- .card.reaction template


tempData =
    { profileImage = "./src/assets/images/avatar-mark-webber.webp"
    , userName = "Mark Webber"
    , type_ = "reacted to your recent post"
    , event = "My first tournament today"
    , date = "1m ago"
    , privateMessage = ""
    , otherPicture = ""
    }


type alias ReactionCard =
    { profileImage : String
    , userName : String
    , type_ : String
    , event : String
    , date : String
    , privateMessage : String
    , otherPicture : String
    }


cardReactionTemplate : ReactionCard -> Html msg
cardReactionTemplate card =
    div [ class "card reaction" ]
        [ div [ class "image-wrapper" ]
            [ img [ src card.profileImage, alt "user profile", Html.Attributes.height 45, Html.Attributes.width 45 ] []
            ]
        , div [ class "text-wrapper" ]
            [ p []
                [ span [ class "username" ] [ text (card.userName ++ " ") ]
                , text (card.type_ ++ " ")
                , span [ class "event" ] [ text card.event ]
                ]
            , time [ datetime "1994 09 23" ] [ text card.date ]
            ]
        ]



-- CSS
--! I tried using elm-css but I didn't like it
-- type alias CssRule =
--     List Style
-- createCss : List { a | val : b } -> List b
-- createCss styles =
--     List.map (\prop -> prop.val) styles
-- pxToRem : Float -> Float
-- pxToRem px =
--     px / 16
-- -- ROOT COMPONENT
-- rootComponent : CssRule
-- rootComponent =
--     let
--         props =
--             [ { val = displayFlex }
--             , { val = flexDirection column }
--             ]
--     in
--     createCss props
-- -- HEADER COMPONENT
-- headerComponent : CssRule
-- headerComponent =
--     let
--         props =
--             [ { val = displayFlex }
--             , { val = padding2 (px 0) (px 16) }
--             , { val = marginBlockStart (px 24) }
--             -- , { val = hover [ backgroundColor (hex "#fefefe") ] }
--             ]
--     in
--     createCss props
-- notifications : CssRule
-- notifications =
--     let
--         props =
--             [ { val = fontSize (rem (pxToRem 20)) }
--             ]
--     in
--     createCss props
-- notificationsNumber : CssRule
-- notificationsNumber =
--     let
--         props =
--             [ { val = color (hex "#FFFFFF") }
--             , { val = backgroundColor (hex "#0A327B") }
--             , { val = fontSize (rem (pxToRem 16)) }
--             , { val = fontWeight (int 800) }
--             , { val = padding4 (px 4) (px 11) (px 4) (px 11) }
--             , { val = borderRadius (px 6) }
--             ]
--     in
--     createCss props
-- markAsReadBtn : CssRule
-- markAsReadBtn =
--     let
--         props =
--             [ { val = color (hex "#5E6778") }
--             , { val = backgroundColor transparent }
--             , { val = border zero }
--             , { val = cursor pointer }
--             , { val = marginInlineStart auto }
--             ]
--     in
--     createCss props
-- -- MAIN COMPONENT
-- -- mainComponent : CssRule
-- -- mainComponent =
-- --     let
-- --         props =
-- --             [ { val = }
-- --             ]
-- --     in
-- --     createCss props
-- -- FOOTER COMPONENT
-- footerComponent : CssRule
-- footerComponent =
--     let
--         props =
--             [ { val = marginBlockStart auto }
--             ]
--     in
--     createCss props
