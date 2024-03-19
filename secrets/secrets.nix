let
  mxkrsv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkupsms0fUp4SflgKwVBfKRXi8eY51cgbex4aXerC5B mxkrsv@sayaka";
  users = [ mxkrsv ];

  sayaka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPl3dGV0IV4p86Spql+QiZ6jEKqvD3XyY9c+wj3/yjZb";
  systems = [ sayaka ];
in
{
  "gh_hosts.age".publicKeys = users;
  "glab_config.age".publicKeys = users;

  "singbox_uuid_mxkrsv".publicKeys = users ++ systems;
}
