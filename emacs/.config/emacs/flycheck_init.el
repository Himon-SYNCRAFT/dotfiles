;;; init.el --- Summary
;;; Commentary:
;;; Code:

;; remove default transparency (from .Xresources)
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;; add transparent background in version 29
(set-frame-parameter nil 'alpha-background 87)
(add-to-list 'default-frame-alist '(alpha-background . 87))

;; minimal ui
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; show relative line numbers
(global-display-line-numbers-mode)
(display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; saving history of minibuffer
(setq history-length 100)
(savehist-mode 1)

 ;; remove splash screen
(setq inhibit-splash-screen t)

;;; When opening a file that is a symbolic link, don't ask whether I
;;; want to follow the link. Just do it
(setq find-file-visit-truename t)

;; autopair (,[,{ etc.
(electric-pair-mode)

;; set ssh for tramp-mode
(setq tramp-default-method "ssh")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq package-selected-packages '(use-package
                                   catppuccin-theme
                                   company
                                   company-box
                                   dap-mode
                                   doom-modeline
                                   evil
                                   flycheck
                                   flycheck-phpstan
                                   fzf
                                   lsp-mode
                                   lsp-ui
				   org-bullets
                                   php-mode
				   ranger
                                   tree-sitter
                                   tree-sitter-langs
                                   which-key
                                   yasnippet
                                   ))

(if (package-installed-p 'catppuccin-theme)
  (load-theme 'catppuccin :no-confirm))

(setq catppuccin-flavor 'macchiato) ;; or 'latte, 'macchiato, or 'mocha
(catppuccin-reload)

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package fzf
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        fzf/grep-command "rg --no-heading -nH"
        ;; fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))

(ranger-override-dired-mode t)

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
  (evil-define-key 'normal 'global (kbd "SPC SPC") 'lsp-execute-code-action)
  (evil-define-key 'normal 'global (kbd "<leader>rn") 'lsp-rename)
  (evil-define-key 'normal 'global (kbd "K") 'lsp-ui-doc-show)
  (evil-define-key 'normal 'global (kbd "gd") 'xref-find-definitions)
  (evil-define-key 'normal 'global (kbd "gr") 'xref-find-references)
  (evil-define-key 'normal 'global (kbd "<leader>v") 'evil-window-vsplit)
  (evil-define-key 'normal 'global (kbd "<leader>h") 'evil-window-split)
  (evil-define-key 'normal 'global (kbd "<leader>e") 'fzf-git)
  (evil-define-key 'normal 'global (kbd "<leader>g") 'fzf-grep)
  (evil-define-key 'normal 'global (kbd "<f2>") 'ranger)
  (evil-define-key 'normal 'global (kbd "SPC f") 'lsp-format-buffer)
  (evil-define-key 'normal 'global (kbd "SPC m h") 'org-toggle-heading)
  (evil-define-key 'normal 'global (kbd "SPC m i") 'org-toggle-item)
  (evil-define-key 'normal 'global (kbd "RET") 'org-toggle-checkbox)
  (evil-define-key 'normal 'global (kbd "M-RET") 'eval-buffer)
  ;; (evil-define-key 'visual 'global (kbd "M-RET") 'eval-region)
  (evil-define-key 'visual 'global (kbd "M-RET") 'eval-expression)
)

(evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("86b46391e744b8fea6015224acd27e95de4c25dfd519167126e7cc5d45435864" default)))
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
  (lsp-enable-which-key-integration t)
  (setq lsp-headerline-breadcrumb-enable nil))

(lsp-diagnostics-mode)

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-php-phpcs-executable "~/.config/composer/vendor/bin/phpcs")

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(lsp-ui-mode)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\var\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\tmp\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\bin\\'")
  ;; or
  ;;(add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'")
  )

(use-package lsp-treemacs
  :after lsp)

(use-package company
  :unless (file-remote-p default-directory)
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map ("<tab>" . company-complete-selection))
  (:map lsp-mode-map ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
)

(setq tab-always-indent 'complete)

(use-package company-box
  :unless (file-remote-p default-directory)
  :hook (company-mode . company-box-mode))

(use-package dap-mode
  :unless (file-remote-p default-directory)
  :config
  (dap-mode 1))

(defun read-file-into-variable (filename)
  "Return the value read from FILENAME."
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))

(defun trim-string (str)
  "Trimming whitespace from string (STR)."
  (if (string-blank-p str)
      ""
    (replace-regexp-in-string "\\`[[:space:]\n]*" "" (replace-regexp-in-string "[[:space:]\n]*\\'" "" str))))

(setq lsp-intelephense-licence-key (trim-string (read-file-into-variable "~/intelephense/license.txt")))

(setq gc-cons-threshold (* 100 1024 1024)
  read-process-output-max (* 1024 1024)
  treemacs-space-between-root-nodes nil
  lsp-idle-delay 0.1)

(use-package php-mode
  :mode "\\.php\\'"
  :after flycheck lsp-mode
  :hook
  (php-mode . lsp-deferred)
  (php-mode . tree-sitter-hl-mode)
  (php-mode . (lambda() (flycheck-add-next-checker 'lsp 'php-phpcs)))
  )

(use-package org-bullets
  :hook org-mode . (lambda() (org-bullets-mode 1)))

(setq org-agenda-files '("~/Remote/syncraft@google/org")
  org-default-notes-file (expand-file-name "notes.org" org-directory)
  org-ellipsis " ▼ "
  org-log-done 'time
  org-hide-emphasis-markers t
  org-table-convert-region-max-lines 20000
  org-todo-keywords
  '((sequence
     "TODO(t)"
     "PROCESSING(p)"
     "TESTING(v)"
     "WAIT(w)"
     "|"
     "DONE(d)"
     "CANCELLED(c)" )))

;;; init.el ends here
