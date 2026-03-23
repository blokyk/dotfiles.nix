# A clipboard history manager
{ ... }: {
  imports = [ (import <zoeee/hm-modules>) ];

  services.ringboard = {
    x11.enable = true;
  };
}
