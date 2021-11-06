# BakeCode Recipe

Implementation and parser of BakeCode Recipe.

## Things to note when contributing

- Prefer `UnmodifiableListView`, `UnmodifiableMapView`, `UnmodifiableSetView`, etc... over `List.unmodifiable`, `Map.unmodifiable`, `Set.unmodifiable`. This allows better type hinting and reduced runtime errors.
