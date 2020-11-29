module day1 where

open import IO
open import Data.String
open import Codata.Musical.Costring
open import Codata.Musical.Notation
open import Relation.Nullary
open import Relation.Nullary.Decidable
open import Data.List
open import Data.Char
open import Data.Nat
open import Data.Unit.Polymorphic

open import Agda.Builtin.String
open import Agda.Builtin.Bool
open import Function using (_∘_)

infile : String
infile = "../inputs/day1"

getString : IO String
getString = readFiniteFile infile

eqToℕ : Char → Char → ℕ
eqToℕ a b with ⌊ a Data.Char.≈? b ⌋
... | false = 0
... | true = toℕ a ∸ 48 -- ascii zero

-- I am not comparing the last element with the first element here
captcha : List Char -> ℕ
captcha [] = zero
captcha (x ∷ []) = zero
captcha (x ∷ (y ∷ xs)) = captcha (y ∷ xs) + eqToℕ x y

part1 : IO ⊤
part1 = ♯ getString >>= \s -> ♯ (putStrLn∞ ∘ toCostring ∘ primShowNat ∘ captcha ∘ toList) s

main = run part1
