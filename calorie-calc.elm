import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on)
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
--model = Model 150 66 30 Female 0

-- Update
type Msg
    = Weight String
    | Height String
    | Age String
    | SetSex Sex

update: Msg -> Model -> Model
update msg model =
    case msg of
        Weight newWeightString ->
            calcCalories { model | weightInLbs = Result.withDefault 0 (String.toFloat newWeightString) }

        Height newHeightString ->
            calcCalories { model | heightInInches = Result.withDefault 0 (String.toFloat newHeightString) }

        Age newAgeString ->
            calcCalories { model | ageYears = Result.withDefault 0 (String.toInt newAgeString) }

        SetSex newSex ->
            calcCalories { model | sex = newSex }

calcCalories: Model -> Model
calcCalories model =
    let
        (weightInKg, heightInCm) =
            (model.weightInLbs / 2.2,  model.heightInInches * 2.54)

    in
        { model | calorieNeeds = calcCalorieNeeds weightInKg heightInCm model.ageYears }

calcCalorieNeeds: Float -> Float -> Int -> Int
calcCalorieNeeds weightInKg heightInCm ageYears =
    round ((10 * weightInKg) + (6.25 * heightInCm) - (5 * Basics.toFloat ageYears))

view : Model -> Html Msg
view model =
    div []
        [ div []
            [ h1 [] [ text "Basil Metabolic Rate Calories" ]
            ]
        , div [] [ label [] [ text "How much do you weigh?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.weightInLbs), onInput Weight ] []
                 ]
        , div [] [ label [] [ text "How tall are you?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.heightInInches), onInput Height ] []
                 ]
        , div [] [ label [] [ text "How old are you?" ]
                 , input [ type_ "number", Html.Attributes.value (toString model.ageYears), onInput Age ] []
                 ]
        , div [] [ label [] [ text "What is your biological sex?" ]
                 , select [ required True ]
                    [ option [ Html.Attributes.value "Female" ] [ text "Female" ]
                    , option [ Html.Attributes.value "Male" ] [ text "Male" ]
                    ]
                 ]
        , div []
            [ p [] [ text "You basil metabolic rate daily calorie intake is:" ]
            , h2 [] [ text ((toString model.calorieNeeds) ++ " calories") ]
            ]
        ]
