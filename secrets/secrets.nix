let
  mxkrsv-sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkupsms0fUp4SflgKwVBfKRXi8eY51cgbex4aXerC5B mxkrsv@sayaka";
  mxkrsv-homura = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpUBOdwjO4iYwQiPQ9vDtvolAas4rBzp/Bc2tv0Zk8h mxkrsv@homura";
  users = [ mxkrsv-sayaka mxkrsv-homura ];

  sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPl3dGV0IV4p86Spql+QiZ6jEKqvD3XyY9c+wj3/yjZb";
  homura = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbn7RG/45tR/xBncAYUkQeyh33qja4tdwlfWq5ROM+E";
  systems = [ sayaka homura ];
in
{
  "gh_hosts.age".publicKeys = users;
  "glab_config.age".publicKeys = users;

  "singbox_uuid_mxkrsv.age".publicKeys = users ++ systems;
}
