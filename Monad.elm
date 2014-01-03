module Monad where

type M a = Maybe a

map : (a -> b) -> M a -> M b
map fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing |> Just

filter : (a -> Bool) -> Maybe a -> Maybe a
filter fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> if fn thing then monad else Nothing

flatmap : (a -> Maybe b) -> Maybe a -> Maybe b
flatmap fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing
