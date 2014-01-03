module Monad where

type M = Maybe a

map : (a -> b) -> M -> Maybe b
map fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing |> Just

filter : (a -> Bool) -> M -> M
filter fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> if fn thing then monad else Nothing

flatmap : (a -> Maybe b) -> M -> Maybe b
flatmap fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing
