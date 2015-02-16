module Html.Events.Extra where
{-| Additional event handlers for html.

# Typed event decoders
@docs targetValueFloat, targetValueInt, targetValueMaybe, targetValueMaybeFloat, targetValueMaybeInt
@docs targetValueFloatParse, targetValueIntParse, targetValueMaybeFloatParse, targetValueMaybeIntParse

-}

import Html.Events (..)
import Json.Decode as Json
import Result
import String

{-| Floating-point target value.
-}
targetValueFloat : Json.Decoder Float
targetValueFloat =
  Json.customDecoder (Json.at ["target", "valueAsNumber"] Json.float) <| \v ->
    if isNaN v
    then Err "Not a number"
    else Ok v

{-| Integer target value.
-}
targetValueInt : Json.Decoder Int
targetValueInt =
  Json.at ["target", "valueAsNumber"] Json.int

{-| String or empty target value.
-}
targetValueMaybe : Json.Decoder (Maybe String)
targetValueMaybe = Json.customDecoder targetValue (\s -> Ok <| if s == "" then Nothing else Just s)

{-| Floating-point or empty target value.
-}
targetValueMaybeFloat : Json.Decoder (Maybe Float)
targetValueMaybeFloat =
  targetValueMaybe `Json.andThen` \mval ->
    case mval of
      Nothing -> Json.succeed Nothing
      Just _ -> Json.map Just targetValueFloat

{-| Integer or empty target value.
-}
targetValueMaybeInt : Json.Decoder (Maybe Int)
targetValueMaybeInt =
  let traverse f mx = case mx of
                        Nothing -> Ok Nothing
                        Just x  -> Result.map Just (f x)
  in Json.customDecoder targetValueMaybe (traverse String.toInt)

{-| Parse a floating-point value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueFloatParse : Json.Decoder Float
targetValueFloatParse =
  Json.customDecoder targetValue String.toFloat

{-| Parse an integer value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueIntParse : Json.Decoder Int
targetValueIntParse =
  Json.customDecoder targetValue String.toInt

{-| Parse an optional floating-point value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueMaybeFloatParse : Json.Decoder (Maybe Float)
targetValueMaybeFloatParse =
  let traverse f mx = case mx of
                        Nothing -> Ok Nothing
                        Just x  -> Result.map Just (f x)
  in Json.customDecoder targetValueMaybe (traverse String.toFloat)

{-| Parse an optional integer value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueMaybeIntParse : Json.Decoder (Maybe Int)
targetValueMaybeIntParse =
  let traverse f mx = case mx of
                        Nothing -> Ok Nothing
                        Just x  -> Result.map Just (f x)
  in Json.customDecoder targetValueMaybe (traverse String.toInt)
