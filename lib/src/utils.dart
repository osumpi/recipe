part of recipe;

void bake(Recipe recipe) {
  runZoned(
    Baker(recipe, null).run,

    // Zoned to allow diagnostics and reporting.
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        // TOOD: do mqtt stuff
        parent.print(zone, line);
      },
    ),
  );
}
