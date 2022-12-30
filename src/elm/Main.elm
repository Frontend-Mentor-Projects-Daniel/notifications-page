module Main exposing (..)

import Browser
import Css exposing (static)
import Html exposing (..)
import Html.Attributes exposing (alt, attribute, class, datetime, href, id, src)
import Html.Attributes.Aria exposing (ariaDescribedby, ariaLive, role)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, bool, field, int, map7, string)
import List exposing (isEmpty, length)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { status : Status
    , unreadNotifications : Int
    , isRead : Bool
    }


type Status
    = Loading
    | Success (List Notification)
    | Failure


type alias Notification =
    { profileImage : String
    , userName : String
    , type_ : String
    , event : String
    , date : String
    , privateMessage : String
    , otherPicture : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { status = Loading
      , unreadNotifications = 0
      , isRead = False
      }
    , getNotifications
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = GetNotifications (Result Http.Error (List Notification))
    | MarkAllAsRead
    | MarkAsRead


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNotifications result ->
            case result of
                Ok notification ->
                    ( { model | status = Success notification, unreadNotifications = List.length notification }, Cmd.none )

                Err httpError ->
                    let
                        _ =
                            Debug.log "HTTP error" httpError
                    in
                    ( { model | status = Failure }, Cmd.none )

        MarkAllAsRead ->
            ( { model | unreadNotifications = 0, isRead = True }, Cmd.none )

        MarkAsRead ->
            ( { model | unreadNotifications = model.unreadNotifications - 1, isRead = True }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "root" ]
        [ header [ class "header center" ]
            [ h1 [] [ text "Notifications" ]
            , span [ role "status", ariaLive "polite" ]
                [ text (String.fromInt model.unreadNotifications)
                , span [ class "sr-only" ] [ text " new notifications" ]
                ]
            , button [ onClick MarkAllAsRead ] [ text "Mark all as read" ]
            ]
        , main_ [ class "main center stack" ]
            [ case model.status of
                Loading ->
                    p [] [ text "Loading..." ]

                Success notification ->
                    div [ class "cards" ] (List.map (\aNotification -> cardTemplates aNotification model) notification)

                Failure ->
                    p [] [ text "Failure" ]
            ]
        , footer [ class "footer attribution center" ]
            [ text "Challenge by"
            , a [ href "https://www.frontendmentor.io?ref=challenge", Html.Attributes.target "_blank" ] [ text " Frontend Mentor. " ]
            , text "Coded by "
            , a [ href "#" ] [ text "Daniel Arzanipour" ]
            ]
        ]



--* DECODING JSON


getNotifications : Cmd Msg
getNotifications =
    Http.get { url = "./src/data/data.json", expect = Http.expectJson GetNotifications notificationsListDecoder }


notificationsDecoder : Decoder Notification
notificationsDecoder =
    JD.map7 Notification
        (field "profileImage" string)
        (field "userName" string)
        (field "type_" string)
        (field "event" string)
        (field "date" string)
        (field "privateMessage" string)
        (field "otherPicture" string)


notificationsListDecoder : Decoder (List Notification)
notificationsListDecoder =
    JD.list notificationsDecoder



--* CARD TEMPLATES


type alias Card =
    { profileImage : String
    , userName : String
    , type_ : String
    , event : String
    , date : String
    , privateMessage : String
    , otherPicture : String
    }


cardTemplates : Card -> Model -> Html Msg
cardTemplates card model =
    if String.isEmpty card.otherPicture == False then
        cardCommentTemplate card model

    else if String.isEmpty card.privateMessage == True then
        cardReactionTemplate card model

    else
        cardPrivateMessage card model


isRead : Bool -> String
isRead a =
    if a == True then
        "true"

    else
        "false"


cardReactionTemplate : Card -> Model -> Html Msg
cardReactionTemplate card model =
    div [ class "card reaction", attribute "isRead" (isRead model.isRead), onClick MarkAsRead ]
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


cardPrivateMessage : Card -> Model -> Html Msg
cardPrivateMessage card model =
    div [ class "card private-message", attribute "isRead" (isRead model.isRead), onClick MarkAsRead ]
        [ div [ class "image-wrapper" ]
            [ img [ src card.profileImage, alt "user profile", Html.Attributes.height 45, Html.Attributes.width 45 ] []
            ]
        , div [ class "text-wrapper" ]
            [ p []
                [ span [ class "username" ] [ text (card.userName ++ " ") ]
                , text card.type_
                , span [ class "event" ] [ text card.event ]
                ]
            , time [ datetime "1994 09 23" ] [ text card.date ]
            , p [ class "message" ] [ text card.privateMessage ]
            ]
        ]


printPrivateMessage : String -> Html Msg
printPrivateMessage msg =
    if String.isEmpty msg then
        p [ class "d-none" ] []

    else
        p [ class "message" ] [ text msg ]


cardCommentTemplate : Card -> Model -> Html Msg
cardCommentTemplate card model =
    div [ class "card comment", attribute "isRead" (isRead model.isRead), onClick MarkAsRead ]
        [ div [ class "image-wrapper" ]
            [ img [ src card.profileImage, alt "user profile", Html.Attributes.height 45, Html.Attributes.width 45 ] []
            ]
        , div [ class "text-wrapper" ]
            [ p []
                [ span [ class "username" ] [ text card.userName ]
                , text card.type_
                , span [ class "event" ] [ text card.event ]
                ]
            , time [ datetime "1994 09 23" ] [ text "1 week ago" ]
            ]
        , div [ class "other-image" ]
            [ img [ src card.otherPicture, alt "", Html.Attributes.height 45, Html.Attributes.width 45 ] []
            ]
        ]
