{...}: {
  programs.zk = {
    enable = true;
    settings = {
      notebook.dir = "~/Sync/zk";
    };
  };
}
