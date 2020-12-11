module Util.String where

open import Data.List
open import Data.Nat
open import Data.Char
open import Data.String
open import Data.Maybe
open import Data.Bool
open import Function using (_∘_)
open import Data.Bool.Properties using (T?)

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
... | true = (toℕ x ∸ 48) ∷ slurp-number xs

stringToℕ : String -> ℕ
stringToℕ s =  numFromDigits (slurp-number (toList s))

isNewline : Char -> Bool
isNewline '\n' = true
isNewline _ = false

lines : String → List String
lines = Data.String.wordsBy (T? ∘ isNewline)
