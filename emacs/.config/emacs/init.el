;; remove default transparency
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;; minimal ui
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; show relative line numbers
(global-display-line-numbers-mode)
(display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(setq inhibit-splash-screen t) ;; remove splash screen

(if (package-installed-p 'catppuccin-theme)
    (load-theme 'catppuccin :no-confirm))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq package-selected-packages '(use-package evil catppuccin-theme lsp-mode lsp-ui flycheck company dap-mode php-mode which-key yasnippet tree-sitter tree-sitter-langs))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; use-package
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

;; Enable Evil
(use-package evil
  :config
  (evil-set-leader nil (kbd ","))
  (evil-define-key 'normal 'global (kbd "C-h") 'windmove-left)
  (evil-define-key 'normal 'global (kbd "C-l") 'windmove-right)
  (evil-define-key 'normal 'global (kbd "C-j") 'windmove-down)
  (evil-define-key 'normal 'global (kbd "C-k") 'windmove-up)
  (evil-define-key 'normal 'global (kbd "<space><space>") 'lsp-execute-code-action)
  (evil-define-key 'normal 'global (kbd "<leader>rn") 'lsp-rename)
  (evil-define-key 'normal 'global (kbd "gd") 'xref-find-definitions)
  (evil-define-key 'normal 'global (kbd "gr") 'xref-find-references)
  (evil-define-key 'normal 'global (kbd "<leader>v") 'evil-window-vsplit)
  (evil-define-key 'normal 'global (kbd "<leader>h") 'evil-window-split)
)
(evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(php-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package tree-sitter)
(use-package tree-sitter-langs)

(which-key-mode)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(setq gc-cons-threshold (* 100 1024 1024)
  read-process-output-max (* 1024 1024)
  treemacs-space-between-root-nodes nil
  company-idle-delay 0.0
  company-minimum-prefix-length 1
  lsp-idle-delay 0.1)

(use-package php-mode
  :mode "\\.php\\'"
  :hook
  (php-mode . lsp-deferred)
  (php-mode . tree-sitter-hl-mode)
  )

