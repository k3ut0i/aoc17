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
open import Data.Product as Prod using(_×_; _,_)
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

splitInHalf : {A : Set} → List A → (List A × List A)
splitInHalf xs = splitAt ⌊ (Data.List.length xs) /2⌋ xs

rotateHalf : {A : Set} → List A → List A
rotateHalf xs with splitInHalf xs
... | fst , snd = snd Data.List.++ fst

reduceCompare : List Char → List Char → ℕ
reduceCompare [] [] = zero
reduceCompare [] (x ∷ ys) = zero
reduceCompare (x ∷ xs) [] = zero
reduceCompare (x ∷ xs) (y ∷ ys) = reduceCompare xs ys + eqToℕ x y

captcha2 : List Char → ℕ
captcha2 xs = reduceCompare xs (rotateHalf xs)

part1 : IO ⊤
part1 = ♯ getString >>= \s -> ♯ (putStrLn∞ ∘ toCostring ∘ primShowNat ∘ captcha ∘ toList) s

-- I should just define a function to pass a List Char → ℕ function as argument
part2 : IO ⊤
part2 = ♯ getString >>= \s -> ♯ (putStrLn∞ ∘ toCostring ∘ primShowNat ∘ captcha2 ∘ toList) s

main = run (♯ part1 >> ♯ part2)
