import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on, targetValue)
import String exposing (..)
import Json.Decode as Json

main =
    Html.beginnerProgram { model = model, view = view, update = update }

-- Model
type Sex = Female | Male

type alias Model =
    { weightInLbs: Float
    , heightInInches: Float
    , ageYears: Int
    , sex: Sex
    , calorieNeeds: Int
    }

model: Model
model = calcCalories (Model 150 66 30 Female 0)

-- Update
type Msg
    = Weight String
    | Height String
    | Age String
    | SetSex String

update: Msg -> Model -> Model
update msg model =
    case msg of
        Weight newWeightString ->
            calcCalories { model | weightInLbs = Result.withDefault 0 (String.toFloat newWeightString) }

        Height newHeightString ->
            calcCalories { model | heightInInches = Result.withDefault 0 (String.toFloat newHeightString) }

        Age newAgeString ->
            calcCalories { model | ageYears = Result.withDefault 0 (String.toInt newAgeString) }

        SetSex newSexStr ->
            case newSexStr of
                "Female" ->
                    calcCalories { model | sex = Female }
                "Male" ->
                    calcCalories { model | sex = Male }
                _ ->
                    model

calcCalories: Model -> Model
calcCalories model =
    let
        (weightInKg, heightInCm) =
            (model.weightInLbs / 2.2,  model.heightInInches * 2.54)

    in
        { model | calorieNeeds = calcCalorieNeeds weightInKg heightInCm model.ageYears model.sex }

calcCalorieNeeds: Float -> Float -> Int -> Sex -> Int
calcCalorieNeeds weightInKg heightInCm ageYears sex =
    round ((10 * weightInKg) + (6.25 * heightInCm) - (5 * Basics.toFloat ageYears) + (sexConstantFactor sex))

sexConstantFactor: Sex -> Float
sexConstantFactor sex =
    case sex of
        Female ->
            -161.0
        Male ->
            5.0

-- View
view : Model -> Html Msg
view model =
    div []
        [ div [ class "calc-section calc-title" ]
            [ h1 [] [ text "Basil Metabolic Rate Calories" ]
            ]
        , div [] [ label [] [ text "How much do you weigh?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.weightInLbs), onInput Weight ] []
                 , span [] [ text "pounds" ]
                 ]
        , div [] [ label [] [ text "How tall are you?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.heightInInches), onInput Height ] []
                 , span [] [ text "inches" ]
                 ]
        , div [] [ label [] [ text "How old are you?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.ageYears), onInput Age ] []
                 , span [] [ text "years" ]
                 ]
        , div [] [ label [] [ text "What is your biological sex?" ]
                 , select [ required True, onChange SetSex  ]
                    [ option [ Html.Attributes.value "Female" ] [ text "Female" ]
                    , option [ Html.Attributes.value "Male" ] [ text "Male" ]
                    ]
                 ]
        , div []
            [ p [] [ text "You basil metabolic rate daily calorie intake is:" ]
            , h2 [] [ text ((toString model.calorieNeeds) ++ " calories") ]
            ]
        ]

onChange : (String -> msg) -> Attribute msg
onChange handler =
  on "change" <| Json.map handler <| Json.at ["target", "value"] Json.string