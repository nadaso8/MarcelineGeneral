# See https://discourse.nixos.org/t/use-unstable-version-for-some-packages/32880/2
{ inputs, ... }:
final: _prev: {
  unstable = import inputs.nixpkgs-unstable {
    system = final.system;
    config = final.config;
  };
}
