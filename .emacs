;; Start Emacs as a server
(require 'server)
(unless (server-running-p)
    (server-start))

;; Load package manager
(require 'package)
(require 'cl)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ("elpy" . "http://jorgenschaefer.github.io/packages/")
                  ("gnu" . "http://elpa.gnu.org/packages/")
                  ("org" . "http://orgmode.org/elpa/")
                  ))

(add-to-list 'package-archives source t))
(package-initialize)

;; Install required packages
(defvar prelude-packages
  '(async color-theme color-theme-github dash gruvbox-theme
	  hipster-theme powerline rich-minority smart-mode-line
	  js2-mode ac-js2 evil auto-complete eldoc elpy tabbar
          haskell-mode)
  "A list of packages to ensure are installed at launch.")

(defun prelude-packages-installed-p ()
  "Check if all packages in `prelude-packages' are installed."
  (every #'package-installed-p prelude-packages))

(unless (prelude-packages-installed-p)
  ;; check for new packages (package versions)

  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p prelude-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'prelude-packages)
;;; prelude-packages.el ends here

; Disable stupid menu
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Color theme
(load-theme 'gruvbox t)

;; Indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(setq-default html-indent-offset 2)
(setq-default css-indent-offset 2)

;; Prevent Emacs from making backup files
(setq make-backup-files nil)

;; Show line-number in the mode line
(line-number-mode 1)
;; Show column-number in the mode line
(column-number-mode 1)

(require 'evil)
(evil-mode 1)


(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))


(require 'auto-complete)
(global-auto-complete-mode 1)

(require 'js2-mode)
(setq js2-allow-member-expr-as-function-name t)
(setq js2-allow-rhino-new-expr-initializer t)
(setq js2-include-node-externs t)
(setq js2-include-rhino-externs t)

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-minor-mode-hook 'ac-js2-mode)

;; Line numbers
(global-linum-mode 1)
(setq linum-format "%4d \u2502 ")

; 80 cols line
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(global-whitespace-mode t)

(xclip-mode 1)
(setq scroll-error-top-bottom t)

(add-hook 'js-mode-hook 'hs-minor-mode)

(add-to-list 'load-path "~/workspace/darksmile/tern/emacs/")
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js-mode-hook (lambda () (tern-mode t)))

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

; Config end

; (require 'tabbar)
; (tabbar-mode)

; (global-set-key [M-left] 'tabbar-backward-tab)
; (global-set-key [M-right] 'tabbar-forward-tab)

(defun ext/elpy-setup ()
  (setq elpy-rpc-python-command "python")
  (setq elpy-rpc-backend "jedi")
  (elpy-use-ipython))

(add-hook 'elpy-mode-hook 'ext/elpy-setup)
(add-hook 'python-mode-hook 'elpy-mode)
