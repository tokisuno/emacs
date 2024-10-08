(setq user-init-file "~/Dropbox/.dotfiles/.config/emacs/init.el")
(setq user-emacs-directory "~/Dropbox/.dotfiles/.config/emacs/")

(setq inhibit-startup-message t)
(setq visible-bell t)

(setq auto-save-list-file-prefix "~/Dropbox/org/tmp")
(setq auto-save-file-name-transforms
      '((".*" "~/Dropbox/org/tmp" t)))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode)

(set-face-attribute 'default nil :font "Iosevka Nerd Font" :height 130)

(dolist (mode '(term-mode-hook eshell-mode-hook shell-mode-hook vterm-mode-hook pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
		   ("gnu" . "https://elpa.gnu.org/packages/")
		   ("nongnu" . "https://elpa.nongnu.org/nongnu/")
		   ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(unless package-archive-contents 
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  :init
  (setq dashboard-startup-banner "~/Dropbox/.dotfiles/.config/emacs/banner.jpg")
  (setq dashboard-banner-logo-title "EMACS!")
  (setq dashboard-agenda-time-string-format "%Y-%m-%d %H:%M")
  (setq dashboard-center-content t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-set-init-info t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-items '((agenda . 10))))

(use-package rainbow-mode)

(use-package olivetti
  :hook
  (org-mode . olivetti-mode)
  (dashboard-mode . olivetti-mode))
(setq olivetti-body-width 120)

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Iosevka Nerd Font"))
(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))
(use-package nerd-icons-completion
  :config
  (nerd-icons-completion-mode))
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
(use-package nerd-icons-ivy-rich
  :ensure t
  :init
  (nerd-icons-ivy-rich-mode 1)
  (ivy-rich-mode 1))

(use-package auto-dim-other-buffers)
(add-hook 'after-init-hook (lambda ()
                             (when (fboundp 'auto-dim-other-buffers-mode)
                               (auto-dim-other-buffers-mode t))))

(use-package command-log-mode)

(use-package org
  :hook
  (org-mode . org-indent-mode)
  (org-mode . org-bullets-mode))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-agenda-files '("~/Dropbox/org/"))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Dropbox/org/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  ;; Dailies
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

(use-package org-journal
  :init
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "~/Dropbox/org/journal"
        org-journal-date-format "%Y-%m-%d, %H:%M"))

(use-package pdf-tools)
(pdf-tools-install)
(use-package tablist)

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package vterm
  :ensure t)
(use-package vterm-toggle)
(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
	     '((lambda (buffer-or-name _)
		 (let ((buffer (get-buffer buffer-or-name)))
		   (with-current-buffer buffer
		     (or (equal major-mode 'vterm-mode)
			 (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
	       (display-buffer-reuse-window display-buffer-at-bottom)
	       ;;(display-buffer-reuse-window display-buffer-in-direction)
	       ;;display-buffer-in-direction/direction/dedicated is added in emacs27
	       ;;(direction . bottom)
	       ;;(dedicated . t) ;dedicated is supported in emacs27
	       (reusable-frames . visible)
	       (window-height . 0.3)))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-x" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
  :map ivy-minibuffer-map
  ("TAB" . ivy-alt-done)
  ("C-l" . ivy-alt-done)
  ("C-j" . ivy-next-line)
  ("C-k" . ivy-previous-line)
  :map ivy-switch-buffer-map
  ("C-k" . ivy-previous-line)
  ("C-l" . ivy-done)
  ("C-d" . ivy-switch-buffer-kill)
  :map ivy-reverse-i-search-map
  ("C-k" . ivy-previous-line)
  ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-badger t)
  (doom-themes-visual-bell-config))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-support-imenu t)
  (setq doom-modeline-support-imenu t)
  (setq doom-modeline-height 20)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-time-icon t)
  :config
  (doom-modeline-mode 1))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-C-w-delete nil)
  (setq evil-want-C-w-in-emacs-state t)
  (setq evil-undo-system 'undo-redo))
(evil-mode 1)
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config
  (general-create-definer toki/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (toki/leader-keys
    "SPC" 'find-file :which-key "project view")
  (toki/leader-keys
    "o a" 'org-agenda :which-key "org agenda")
  (toki/leader-keys
    "r f" '(lambda () (interactive) (load-file (expand-file-name "~/.config/emacs/init.el"))) :which-key "run config")
  (toki/leader-keys
    "t t" 'vterm-toggle :which-key "toggle terminal"
    "t o" 'olivetti-mode :which-key "toggle olivetti-mode"
    "t e" 'emojify-mode :which-key "toggle emojify-mode")
  (toki/leader-keys
    "w f" 'evil-write :which-key "write to file"
    "w q" 'evil-quit :which-key "write and quit"
  )
  (toki/leader-keys
    "g g" 'dashboard-open :which-key "open dashboard"
    "g r" 'dashboard-refresh-buffer :which-key "open dashboard"))

(general-define-key
 "C-M-j" 'counsel-switch-buffer)
;; this makes me want to rip my dick off
(general-define-key
 :keymaps '(normal insert visual emacs)
 "C-u" 'evil-scroll-up)
(general-define-key
 :keymaps '(normal insert visual emacs)
 "C-d" 'evil-scroll-down)
