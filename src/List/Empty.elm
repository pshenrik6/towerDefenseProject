module List.Empty exposing (Empty(..), add)


type Empty a
    = List a


add : List a -> a -> List a
add list item =
    case list of
        [] ->
            [ item ]

        x ->
            item :: x
