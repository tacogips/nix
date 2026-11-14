# Function to fix library collisions between packages on Darwin
# Usage: fixLibraryCollision pkgs package [
#   { lib = "lib1.dylib"; source = sourcePackage1; }
#   { lib = "lib2.dylib"; source = sourcePackage2; }
# ]
{ pkgs }:

# package: The package that has conflicting libraries
# libSpecs: A list of library specifications, each containing:
#   - lib: The name of the library file (e.g., "libhtml2md.dylib")
#   - source: The package that provides the canonical version of the library
package: libSpecs:

pkgs.symlinkJoin {
  name = "${package.name or "package"}-fixed";
  paths = [ package ];
  
  # Remove conflicting libraries and create symlinks to the shared ones
  postBuild = ''
    # Process each library specification
    ${builtins.concatStringsSep "\n" (map (spec: ''
      # Remove the conflicting library: ${spec.lib}
      rm -f $out/lib/${spec.lib}
      
      # Create a symlink to the library from the source package
      if [ -d $out/lib ]; then
        ln -sf ${spec.source}/lib/${spec.lib} $out/lib/
      fi
    '') libSpecs)}
  '';
}