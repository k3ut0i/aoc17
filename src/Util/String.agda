module Util.String where

open import Data.List
open import Data.Nat
open import Data.Char
open import Data.String
open import Data.Maybe
open import Agda.Builtin.Bool

numFromDigits : List ℕ -> ℕ
numFromDigits xs = helper xs zero
  where
    helper : List ℕ -> ℕ -> ℕ
    helper [] n = n
    helper (x ∷ xs) n = helper xs (10 * n + x)

slurp-number : List Char -> List ℕ
slurp-number [] = []
slurp-number (x ∷ xs) with (isDigit x)
... | false = []
... | true = toℕ x ∷ slurp-number xs

stringToℕ : String -> ℕ
stringToℕ s =  numFromDigits (slurp-number (toList s))
