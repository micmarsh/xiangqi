module Monad where

type M a = Maybe a

map : (a -> b) -> M a -> M b
map fn monad = flatmap (\v -> Just (fn v)) monad

filter : (a -> Bool) -> M a -> M a
filter fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> if fn thing then monad else Nothing

flatmap : (a -> M b) -> M a -> M b
flatmap fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing
