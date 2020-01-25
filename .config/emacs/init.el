(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :config (evil-collection-init))

(setq-default display-line-numbers 'relative
              indent-tabs-mode nil)

(use-package doom-themes
  :ensure t
  :init
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  :config
  (load-theme 'doom-palenight t)
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (setq doom-modeline-icon (display-graphic-p))
  :config (doom-modeline-mode 1))

(use-package company
  :ensure t
  :init (setq company-idle-delay 0.3)
  :config
  (global-company-mode))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))

(use-package ivy
  :ensure t
  :init (setq ivy-use-virtual-buffers t
	      enable-recursive-minibuffers t)
  :config
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit))

(use-package ivy-posframe
  :ensure t
  :init (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  :config (ivy-posframe-mode 1))

(use-package counsel
  :ensure t)

(use-package projectile
  :ensure t
  :init (setq projectile-project-search-path '("~/code/"))
  :config (projectile-mode))

(use-package counsel-projectile
  :ensure t)

(use-package magit
  :ensure t
  :commands magit
  :init (add-hook 'smerge-mode-hook #'evil-normalize-keymaps))

(use-package evil-magit
  :after magit
  :ensure t)

(use-package general
  :ensure t
  :config
  (general-evil-setup)
  (general-override-mode)
  :commands general-define-key)
  
(use-package which-key
  :ensure t
  :init (setq which-key-popup-type 'minibuffer)
  :config (which-key-mode))

(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(general-define-key 
 :states '(normal emacs)
 :keymaps 'override
 :prefix "SPC"
 "." 'counsel-find-file
 "f" 'counsel-projectile-find-file
 "x" 'counsel-M-x
 "b" 'counsel-switch-buffer
 "G" 'counsel-projectile-git-grep
 "g" 'counsel-projectile-rg
 "p" 'counsel-projectile-switch-project
 "r" 'counsel-buffer-or-recentf
 "m" 'magit
 "s" 'eshell
 "c" 'comment-line
 "w" '(nil :which-key "window")
 "d" 'smerge-mode
 "k" 'kill-buffer-and-window
 "K" 'kill-other-buffers)

(general-define-key
 :states 'visual
 :keymaps 'override
 :prefix "SPC"
 "c" 'comment-or-uncomment-region)

(use-package rotate
  :ensure t
  :commands (rotate-window))

(general-define-key 
 :states '(normal visual emacs)
 :keymaps 'override
 :prefix "SPC w"
 "." 'counsel-find-file
 "/" 'evil-window-vsplit
 "-" 'evil-window-split
 "o" 'delete-other-windows
 "h" 'evil-window-left
 "j" 'evil-window-down
 "k" 'evil-window-up
 "l" 'evil-window-right
 "c" 'evil-window-delete
 "r" 'rotate-window)

(general-define-key
 :states '(normal visual emacs)
 "j" 'evil-next-visual-line
 "k" 'evil-previous-visual-line)

(use-package flycheck
  :ensure t)

(defun elpy-goto-definition-or-rgrep ()
  "Go to the definition of the symbol at point, if found. Otherwise, run `elpy-rgrep-symbol'."
  (interactive)
  (ring-insert find-tag-marker-ring (point-marker))
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol
            (concat "\\(def\\|class\\)\s" (thing-at-point 'symbol) "(")))))

(use-package elpy
  :ensure t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (setq elpy-test-runner 'elpy-test-pytest-runner
        elpy-test-pytest-runner-command '("python" "-m" "pytest" "-p" "no:warnings" "--instafail")
        elpy-rpc-python-command "/usr/bin/python"
        python-shell-interpreter "/usr/bin/python"
        python-shell-interpreter-args "-i")
  (when (load "flycheck" t t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))

(general-evil-define-key '(normal visual) python-mode-map
 :prefix ","
 "e" 'elpy-shell-send-group
 "s" 'elpy-shell-send-group-and-step
 "b" 'elpy-shell-send-buffer
 "t" 'elpy-test
 "d" 'elpy-goto-definition-or-rgrep
 "p" 'pdb)

(use-package zig-mode
  :ensure t)

(general-evil-define-key '(normal visual) zig-mode-map
  :prefix ","
  "c" 'compile
  "r" 'recompile)

(use-package pdf-tools
  :ensure t)

(general-evil-define-key '(normal visual) smerge-mode-map
  :prefix ","
  "n" 'smerge-next
  "u" 'smerge-keep-upper
  "l" 'smerge-keep-lower
  "a" 'smerge-keep-all)

(use-package beacon
  :ensure t
  :config (beacon-mode 1))

(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-ivy
  :ensure t
  :config (all-the-icons-ivy-setup))

(use-package all-the-icons-dired
  :ensure t
  :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package ranger
  :ensure t
  :config (ranger-override-dired-mode t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(doom-modeline-mode t)
 '(package-selected-packages
   '(company-box ivy-posframe all-the-icons-dired all-the-icons-ivy beacon indent-guide evil-collection pdf-tools flycheck zig-mode zig exec-path-from-shell dashboard rotate which-key general evil-magit magit counsel-projectile counsel doom-modeline doom-themes evil-escape projectile ivy elpy use-package evil)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
