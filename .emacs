(setq user-full-name    "Millie Chan"
     user-mail-address "mireechan@gmail.com"
     mail-host-address '"gmail.com")

(setq load-path (append '("~/.emacs.d/themes") load-path))

;;--------- color theme -----------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'darkness t)
(setq load-path (append '("~/.emacs.d/vendor" "~/.emacs.d/themes") load-path))

;;--------- color theme -----------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'darkness t)

;;--------- SCSS-mode --------------
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\" . scss-mode))

;; -------- Emacs persistence ----
(setq backup-directory-alist
     `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
     `((".*" ,temporary-file-directory t)))
(setq backup-by-copying t)

;; remove interlock files
(setq create-lockfiles nil)

;;--------- MISC ------------------
;; Disable toolbar if it is there
;; also: M-x ns-toggle-toolbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;;--------- Tab Settings ------------------
;; Set some basic requirements around input (width 4, don't use tabs),
;; but then also define some magic that will replace tabs if we happen
;; to save a file that has tabs inadvertently added to it, as well as
;; nuke trailing whitespace.  This is the default behaviour; (setq
;; indent-tabs-mode t) in a hook for modes you want left alone.

(setq-default tab-width 4) ;; used by untabify
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Move all temp files to one dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

(when (>= emacs-major-version 24)
 (require 'package)
 (add-to-list
  'package-archives
  '("melpa" . "http://melpa.org/packages/")
  t)
 (package-initialize))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(ansi-term-color-vector
   [unspecified "#0a0a0a" "#cc6666" "#76AA00" "#edd42d" "#0076aa" "#b294bb" "#0076aa" "#c5c8c6"])
 '(custom-safe-themes
   (quote
    ("689e6e1ad4a3e9065912965960873a3462cdc7bdef2982247ac1c03299c8a526" default)))
 '(package-selected-packages (quote (exec-path-from-shell scss-mode web-mode flycheck)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  ;;; using Airbnb's css style-guid. 2 spaces: https://github.com/airbnb/css#formatting
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))
