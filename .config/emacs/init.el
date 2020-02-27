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
  :init (setq evil-collection-company-use-tng nil)
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
 "B" 'magit-blame
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
 "h" 'elpy-doc
 "r" 'xref-find-references
 "n" 'elpy-multiedit-python-symbol-at-point
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("dd854be6626a4243375fd290fec71ed4befe90f1186eb5b485a9266011e15b29" "2c4222fc4847588deb57ce780767fac376bbf5bdea5e39733ff5e380a45e3e46" "8c75e2bdf8d1293c77a752dd210612cfb99334f7edd360a42a58a8497a078b35" "5e0b63e0373472b2e1cf1ebcc27058a683166ab544ef701a6e7f2a9f33a23726" "f7b230ac0a42fc7e93cd0a5976979bd448a857cd82a097048de24e985ca7e4b2" "669e05b25859b9e5b6b9809aa513d76dd35bf21c0f16d8cbb80fb0727dc8f842" "5c9a906b076fe3e829d030a404066d7949e2c6c89fc4a9b7f48c054333519ee7" "e7666261f46e2f4f42fd1f9aa1875bdb81d17cc7a121533cad3e0d724f12faf2" "de43de35da390617a5b3e39b6b27c107cc51271eb95cceb1f43d13d9647c911d" "e47c0abe03e0484ddadf2ae57d32b0f29f0b2ddfe7ec810bd6d558765d9a6a6c" "b9dda6ca36e825766dfada5274cf18d8a5bce70676b786e3260094e0cd8c0e62" "bc99493670a29023f99e88054c9b8676332dda83a37adb583d6f1e4c13be62b8" "5091eadbb87fa0a168a65f2c3e579d1a648d764f12ab9d3ab7bdefca709cd2a5" "32fd809c28baa5813b6ca639e736946579159098d7768af6c68d78ffa32063f4" "9d54f3a9cf99c3ffb6ac8e84a89e8ed9b8008286a81ef1dbd48d24ec84efb2f1" "a4b9eeeabde73db909e6b080baf29d629507b44276e17c0c411ed5431faf87dd" "dc677c8ebead5c0d6a7ac8a5b109ad57f42e0fe406e4626510e638d36bcc42df" "1ca1f43ca32d30b05980e01fa60c107b02240226ac486f41f9b790899f6f6e67" "15ba8081651869ec689c9004288bed79003de5b4ee9c51a9d4a208d9e3439706" "468e235ebcb0d75e8bc0849e6b8a0bf5e8560ba3180b17ce21599d60a35e5816" "1897b97f63e91a792e8540c06402f29d5edcbfb0aafd64b1b14270663d6868ee" "a02836a5807a687c982d47728e54ff42a91bc9e6621f7fe7205b0225db677f07" "4b0b568d63b1c6f6dddb080b476cfba43a8bbc34187c3583165e8fb5bbfde3dc" "a4fa3280ffa1f2083c5d4dab44a7207f3f7bcb76e720d304bd3bd640f37b4bef" "c6b93ff250f8546c7ad0838534d46e616a374d5cb86663a9ad0807fd0aeb1d16" "92d8a13d08e16c4d2c027990f4d69f0ce0833c844dcaad3c8226ae278181d5f3" "0fe9f7a04e7a00ad99ecacc875c8ccb4153204e29d3e57e9669691e6ed8340ce" "53f8223005ceb058848fb92c2c4752ffdfcd771f8ad4324b3d0a4674dec56c44" default))
 '(doom-modeline-mode t)
 '(package-selected-packages
   '(company-box ivy-posframe all-the-icons-dired all-the-icons-ivy beacon indent-guide evil-collection pdf-tools flycheck zig-mode zig exec-path-from-shell dashboard rotate which-key general evil-magit magit counsel-projectile counsel doom-modeline doom-themes evil-escape projectile ivy elpy use-package evil)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
