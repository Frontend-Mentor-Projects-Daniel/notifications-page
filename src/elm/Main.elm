module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (alt, class, datetime, href, id, src)
import Html.Attributes.Aria exposing (ariaDescribedby, ariaLive, role)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, field, int, map7, string)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type Model
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



-- { hasRead = True
--       , unReadMessages = 5
--       , isPrivateMessage = False
--       , isComment = False
--       , notifications = 0
--       }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getNotifications
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = GetNotifications (Result Http.Error (List Notification))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNotifications result ->
            case result of
                Ok notification ->
                    ( Success notification, Cmd.none )

                Err httpError ->
                    let
                        _ =
                            Debug.log "HTTP error" httpError
                    in
                    ( Failure, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "root" ]
        [ -- h1 [] [ text (Debug.toString testDecoder) ],
          header [ class "header center" ]
            [ h1 [] [ text "Notifications" ]
            , span [ role "status", ariaLive "polite" ]
                [ text "0"
                , span [ class "sr-only" ] [ text " new notifications" ]
                ]
            , button [] [ text "Mark all as read" ]
            ]
        , main_ [ class "main center stack" ]
            [ case model of
                Loading ->
                    p [] [ text "Loading..." ]

                Success notification ->
                    div [ class "cards" ] (List.map (\aNotification -> cardReactionTemplate aNotification) notification)

                Failure ->
                    p [] [ text "Failure" ]

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
