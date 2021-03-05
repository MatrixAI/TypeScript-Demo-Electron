import (
  # using https://github.com/NixOS/nixpkgs/pull/115174
  let rev = "de0e7dc75f72595d444fed09b7a18b8763a646e2"; in
  fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz"
)
