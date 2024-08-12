---- MODULE Test ----
ℕ == {0,1,2,3,4,5}
a ⊕ b ≜ a[1] \* Intentional runtime error
op(a, b) ≜ a ⊕ b
op2 ≜ ∀ x, y ∈ ℕ : op(x, y)
ASSUME op2
====
