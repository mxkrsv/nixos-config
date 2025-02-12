let
  poli-sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGZKFPQNRf1H/4k0wjCMiATRBQ1BoEYPSFX6EhGInWw poli@sayaka";
  #poli-homura = "";
  users = [ poli-sayaka ];

  sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFarrIP0OqMflQwktGYk084TzztWipdWtgMTPv5+cIR";
  #homura = "";
  systems = [ sayaka ];
in
{
  "singbox_uuid.age".publicKeys = users ++ systems;
}
