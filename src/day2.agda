module day2 where

open import IO
open import Codata.Musical.Costring
open import Codata.Musical.Notation
open import Data.Unit.Polymorphic using(⊤)
open import Data.String
open import Data.Nat
open import Data.List as L
open import Data.Vec as V
open import Data.Maybe as M
open import Data.Product using (_,_ ; _×_)
open import Function using(_∘_)
open import Agda.Builtin.String using(primShowNat)
open import Agda.Builtin.Bool
open import Agda.Builtin.Nat using(mod-helper ; div-helper)
open import Relation.Binary.PropositionalEquality as Eq using(_≡_)
open import Relation.Unary using (∁)
open import Util.String using (lines)
open import Util.List using (foldlₘ)

readLines : String -> IO (List String)
readLines f = ♯ readFiniteFile f IO.>>= \s → ♯ return (lines s)

getSpreadsheet : List String -> List (List ℕ)
getSpreadsheet = L.map (\s -> L.map Util.String.stringToℕ (words s)) 

max∸min : List ℕ → ℕ
max∸min xs with (foldlₘ _⊔_ xs) , (foldlₘ _⊓_ xs)
... | nothing , nothing = zero
... | nothing , just x = zero
... | just x , nothing = zero
... | just x , just y = x ∸ y

part1 : IO ⊤
part1 = ♯ readLines "../inputs/day2" IO.>>=
        \s → ♯ (putStrLn∞ ∘ toCostring ∘ primShowNat)
                          (L.foldl _+_ 0 (L.map max∸min (getSpreadsheet s)))

-- divides a b is true iff  b = c*a for some c
{-
divides : ℕ → ℕ → Bool
divides a b with compare a b
... | less .a k = divides a (suc k)
... | equal .a = true
... | greater .b k = false
-}

divides : ℕ → ℕ → Bool
divides zero m = false -- and error technically
divides (suc n) m = zero ≡ᵇ mod-helper 0 n m n

findFirst : (ℕ → Bool) → List ℕ → Maybe ℕ
findFirst f [] = nothing
findFirst f (x ∷ xs) with f x
... | false = findFirst f xs
... | true = just x

-- once
delete : ℕ → List ℕ → List ℕ
delete y [] = []
delete y (x ∷ xs) with x  ≡ᵇ y
... | false = x ∷ delete y xs
... | true = xs

findPair₂ : (ℕ → ℕ → Bool) → List ℕ → List ℕ → Maybe (ℕ × ℕ)
findPair₂ f [] ys = nothing
findPair₂ f (x ∷ xs) ys with findFirst (f x) (delete x ys)
... | nothing = findPair₂ f xs ys
... | just y = just (x , y)

findPair : (ℕ → ℕ → Bool) → List ℕ → Maybe (ℕ × ℕ)
findPair f xs = findPair₂ f xs xs

divisiblePair : List ℕ → Maybe (ℕ × ℕ)
divisiblePair = findPair divides

-- n/m
divide : ℕ → ℕ → Maybe ℕ
divide n zero = nothing
divide n (suc m) = just (div-helper 0 m n m)

divideThePair : List ℕ → Maybe ℕ
divideThePair xs with divisiblePair xs
... | nothing = nothing
... | just (m , n) = divide n m

collectMaybe : ∀{A : Set} → List (Maybe A) → List A
collectMaybe [] = []
collectMaybe (nothing ∷ xs) = collectMaybe xs
collectMaybe (just x ∷ xs) = x ∷ collectMaybe xs

part2 : IO ⊤
part2 = ♯ readLines "../inputs/day2" IO.>>=
        λ l → ♯ (putStrLn∞ ∘ toCostring ∘ primShowNat)
                (L.foldl _+_ 0 (collectMaybe (L.map divideThePair (getSpreadsheet l)) ))

main = run ( ♯ part1 >> ♯ part2)
