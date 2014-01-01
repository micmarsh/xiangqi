module Monad where

map : (a -> b) -> Maybe a -> Maybe b
map fn monad =
    case monad of
        Nothing -> Nothing
        Just thing -> fn thing |> Just
