module Util.List where

open import Data.List
open import Data.Nat
open import Data.Maybe
open import Data.Bool

foldlₘ : ∀{a}{A : Set a} → (A → A → A) → List A → Maybe A
foldlₘ f [] = nothing
foldlₘ f (x ∷ xs) = just (foldl f x xs)
