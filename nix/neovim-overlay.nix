# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Used to connect the keys for changing sway windows and nvim windows
  vim-sway-nav = pkgs.vimUtils.buildVimPlugin {
    name = "vim-sway-nav";
    src = pkgs.fetchFromSourcehut {
      owner = "~jcc";
      repo = "vim-sway-nav";
      rev = "dd6fc84e26c30ed10be8ab4877511f89c7e58240";
      hash = "sha256-eimWjUaG/5Y195yoA52vyQBxwEijzDJXWYaDwy+xyTo=";
    };
  };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    # luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    ultisnips
    telescope-manix

    # nvim-cmp (autocompletion) and extensions
    persisted-nvim
    project-nvim
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    # cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    cmp-nvim-ultisnips
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    # ^ nvim-cmp extensions
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    todo-comments-nvim # todo comments
    better-escape-nvim # nice version of jk <esc>
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    oil-nvim # file explorer
    toggleterm-nvim
    alpha-nvim
    nvim-ufo
    # pretty-fold-nvim # Seems to break things
    # ^ UI
    # language support
    # ^ language support
    # navigation/editing enhancement plugins
    # vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    nvim-highlight-colors # https://github.com/brenoprata10/nvim-highlight-colors/
    # ^ navigation/editing enhancement plugins
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    nvim-autopairs
    leap-nvim
    nvim-comment
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    #(mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    #(mkNvimPlugin inputs.dracula-nvim "dracula.nvim") # colorscheme
    # (mkNvimPlugin inputs.harpoon "harpoon") # harpoon
    harpoon2 # Temp while I debug, need to move up
    (mkNvimPlugin inputs.nerdy "nerdy") # nerdy.nvim
    # ^ bleeding-edge plugins from flake inputs
    dracula-nvim
    which-key-nvim
    vim-sway-nav
    vimtex
    hardtime-nvim # maybe start disabled if it gets annoying
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    lazygit
    texlab
    texliveMedium
    zathura
    manix
    pplatex
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
