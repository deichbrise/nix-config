{ pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;  

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
    [ 
        pkgs.vim
        pkgs.alacritty
        pkgs.vscode
        pkgs.thefuck
        pkgs.fzf-zsh
        pkgs.fzf
        pkgs.colima
        pkgs.docker
    ];

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
    
    users.users.pstammer = {
      name = "pstammer";
      home = "/Users/pstammer";
    }; 
    
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    
    home-manager.users.pstammer = { pkgs, config, ... }: {
        home.stateVersion = "23.11";
        home.homeDirectory = "/Users/pstammer";
        home.enableNixpkgsReleaseCheck = false;

        fonts.fontconfig.enable = true;

        home.packages = [
            pkgs.nerdfonts
        ];

        programs.home-manager.enable = true;

        programs.git = {
          enable = true;
          userEmail = "pstammer@reliabi.com";
          userName = "Pascal Stammer";
        };

        programs.direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
        
        programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
                ll = "ls -l";
                rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin";
            };
            history.size = 10000;

            oh-my-zsh = {
                enable = true;
                plugins = [ "git" "thefuck" "tmux" "zsh-interactive-cd"];
                theme = "robbyrussell";
            };
        };

        programs.tmux = { # my tmux configuration, for example
            enable = true;
            keyMode = "vi";
            clock24 = true;
            historyLimit = 10000;
            plugins = with pkgs.tmuxPlugins; [
                vim-tmux-navigator
                gruvbox
                cpu
                {
                  plugin = catppuccin;
                  extraConfig = '' 
                  set -g @catppuccin_flavour 'mocha'
                  set -g @catppuccin_window_tabs_enabled on
                  set -g @catppuccin_date_time "%H:%M"
                  '';
                }
                {
                  plugin = resurrect;
                  extraConfig = ''
                  set -g @resurrect-strategy-vim 'session'
                  set -g @resurrect-strategy-nvim 'session'
                  set -g @resurrect-capture-pane-contents 'on'
                  '';
                }
                {
                  plugin = continuum;
                  extraConfig = ''
                  set -g @continuum-restore 'on'
                  set -g @continuum-boot 'on'
                  set -g @continuum-save-interval '10'
                  '';
                }
            ];
            extraConfig = ''
                new-session -s main
                bind-key -n C-a send-prefix
                set -g status-position top
                set -g status-style 'bg=#1e1e2e'
            '';
        };

        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            extraPackages = [
                pkgs.nodejs_21
                pkgs.lazygit
            ];
        };

        xdg.configFile.nvim = {
            source = config.lib.file.mkOutOfStoreSymlink "/Users/pstammer/.config/nix-darwin/programs/neovim/config";
            recursive = true;
        };

        programs.alacritty = {
            enable = true;
            settings = {
                env = {
                    "TERM" = "xterm-256color";
                };

                window = {
                    padding.x = 10;
                    padding.y = 10;
                    opacity = 0.9;
                };

                font = {
                    size = 11.0;

                    normal.family = "FiraCode Nerd Font";
                    bold.family = "FiraCode Nerd Font";
                    italic.family = "FiraCode Nerd Font";
                };

                cursor.style = "Beam";

                colors = {
                    # Default colors
                    primary = {
                        background = "0x1b182c";
                        foreground = "0xcbe3e7";
                    };

                    # Normal colors
                    normal = {
                    black =   "0x100e23";
                    red =     "0xff8080";
                    green =   "0x95ffa4";
                    yellow =  "0xffe9aa";
                    blue =    "0x91ddff";
                    magenta = "0xc991e1";
                    cyan =    "0xaaffe4";
                    white =   "0xcbe3e7";
                    };

                    # Bright colors
                    bright = {
                    black =   "0x565575";
                    red =     "0xff5458";
                    green =   "0x62d196";
                    yellow =  "0xffb378";
                    blue =    "0x65b2ff";
                    magenta = "0x906cff";
                    cyan =    "0x63f2f1";
                    white = "0xa6b3cc";
                    };
                };
            };
        };
    };
}
