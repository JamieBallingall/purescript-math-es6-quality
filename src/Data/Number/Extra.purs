module Data.Number.Extra
  ( equal
  , notEqual
  , isInfinite
  , isInfinity
  , isNegInfinity
  , isPosZero
  , isNegZero
  , minValue
  , maxValue
  , printNumber
  ) where

import Prelude
import Data.Number (isFinite, isNaN)

-- | A more exact equality. Notably:
-- |   `eq nan nan == false`
-- | but
-- |   `equal nan nan == true`.
-- | Also
-- |   `eq (-0.0) 0.0 == true`
-- | but
-- |   `equal (-0.0) 0.0 == false`.
equal :: Number -> Number -> Boolean
equal x y = x == y && 1.0 / x == 1.0 / y || isNaN x && isNaN y

-- | True exactly when `equal` is false
notEqual :: Number -> Number -> Boolean
notEqual x y = not (equal x y)

-- | Returns true if equal to `infinity` or `-infinity`
isInfinite :: Number -> Boolean
isInfinite x = not (isFinite x || isNaN x)

-- | Returns true if exactly equal to `infinity`.
isInfinity :: Number -> Boolean
isInfinity x = isInfinite x && x > 0.0

-- | Returns true if exactly equal to `-infinity`.
isNegInfinity :: Number -> Boolean
isNegInfinity x = isInfinite x && x < 0.0

-- | Returns true if exactly equal to 0.0 and not -0.0.
-- | `isPosZero (-0.0) == false`
-- | `isPosZero 0.0 == true`
isPosZero :: Number -> Boolean
isPosZero x = x == 0.0 && 1.0 / x > 0.0

-- | Returns true if exactly equal to -0.0 and not 0.0.
-- | `isNegZero (-0.0) == true`
-- | `isNegZero 0.0 == false`
isNegZero :: Number -> Boolean
isNegZero x = x == 0.0 && 1.0 / x < 0.0

-- | The smallest positive numeric value representable in JavaScript.
-- | Approximately equal to 5E-324. See
-- | [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_VALUE)
foreign import minValue :: Number

-- | The maximum numeric value representable in JavaScript. Approximately equal
-- | to 1.79E+308. See
-- | [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE)
foreign import maxValue :: Number

-- | Identical to `show` but negative zero is rendered to "-0.0" rather than
-- | "0.0"
printNumber :: Number -> String
printNumber x = if isNegZero x then "-0.0" else show x
