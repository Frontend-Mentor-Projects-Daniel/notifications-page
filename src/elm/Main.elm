module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (alt, attribute, class, datetime, href, id, src)
import Html.Attributes.Aria exposing (ariaLive, role)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, field, int, string)
import Set exposing (..)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



--* MODEL


type alias Model =
    { status : Status
    , unreadNotifications : Int
    , isRead : Bool
    , clickedNotifications : Set.Set Int
    }


type Status
    = Loading
    | Success (List Notification)
    | Failure


type alias Notification =
    { id : Int
    , profileImage : String
    , userName : String
    , type_ : String
    , event : String
    , date : String
    , privateMessage : String
    , otherPicture : String
    }


type NotificationId
    = Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( { status = Loading
      , unreadNotifications = 0
      , isRead = False
      , clickedNotifications = Set.empty
      }
    , getNotifications
    )



--* SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



--* UPDATE


type Msg
    = GetNotifications (Result Http.Error (List Notification))
    | MarkAllAsRead


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNotifications result ->
            case result of
                Ok notification ->
                    ( { model | status = Success notification, unreadNotifications = List.length notification, clickedNotifications = Set.fromList (getIds notification) }, Cmd.none )

                Err httpError ->
                    let
                        _ =
                            Debug.log "HTTP error" httpError
                    in
                    ( { model | status = Failure }, Cmd.none )

        MarkAllAsRead ->
            ( { model | unreadNotifications = 0, isRead = True }, Cmd.none )


getIds : List { a | id : b } -> List b
getIds list =
    List.map (\el -> el.id) list



--* VIEW


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



--* HTTP REQUESTS


getNotifications : Cmd Msg
getNotifications =
    Http.get { url = "./src/data/data.json", expect = Http.expectJson GetNotifications notificationsListDecoder }



--* DECODING JSON


notificationsDecoder : Decoder Notification
notificationsDecoder =
    JD.map8 Notification
        (field "id" int)
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
    { id : Int
    , profileImage : String
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
    div [ class "card reaction", attribute "isRead" (isRead model.isRead) ]
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

            -- , p [] [ text (Debug.toString (Set.member 1 card.id)) ]
            ]
        ]


cardPrivateMessage : Card -> Model -> Html Msg
cardPrivateMessage card model =
    div [ class "card private-message", attribute "isRead" (isRead model.isRead) ]
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
    div [ class "card comment", attribute "isRead" (isRead model.isRead) ]
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
