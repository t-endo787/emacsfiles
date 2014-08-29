;;load-path add 
(defun add-to-load-path(&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

;;cl package load
(require 'cl)

;;php-mode load
(when (require 'php-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))
  (setq php-serch-url "http://jp.php.net/ja/")
  (setq php-serch-url "http://jp.php.net/manual/ja/"))

;;php-mode indent
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-bassic-offset 4)
  
;; (c-set-offset 'case-label '+) ;
(c-set-offset 'arglist-intro '+) ;
(c-set-offset 'arglist-close '+)) ;

(add-hook 'php-mode-hook 'phpindent-hook)


;;auto-install 
(when (require 'auto-install nil t)
;;install-directory
  (setq auto-install-directory "~/.emacs.d/elisp/")
;;Emacs-wiki
  (auto-install-update-emacswiki-package-name t)
;;instakk-elisp
  (auto-install-compatibility-setup))


;;auto-complete init
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs/elisp/ac/dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;twittering mode
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
(require 'twittering-mode)
(setq twittering-status-format "%i @%s %S %p: n %T
[%@]%r %R %f%Ln--------------------------------------")

(setq twittering-icon-mode t)
(setq twittering-convert-fix-size 40)
(setq twittering-timer-interval 40)

(setq twittering-account-authorization 'authorized)
(setq twittering-oauth-access-token-alist
      '(("oauth_token" . "288785464-jiCFbNG8aas7YrrMSEcygnwZFbeJuQZGpzDxiiKi")
	("oauth_token_secret" . "PzVip8tuUlIIXsgCyXEFVtCCt23NsP5axIEsJ6MmirnrR")
	("user_id" . "288785464")
	("screen_name" . "franf0x")))


;;color-moccur config
(when (require 'color-moccur nil t)

;;M-o is occur-by-moccur
(define-key global-map (kbd "M-o") 'occur-by-moccur)
;;SPC AND serch
(setq moccur-split-word t)
;;directory serch
(add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
(add-to-list 'dmoccur-exclusion-mask "^#.+#$")
;;Migemo use
(when (and (executable-find "cmigemo")
	   (require 'migemo nil t))
  (setq moccur-use-migemo t)))

;;Moccure-edit conf
(require 'moccur-edit nil t)

;;flymake use conf
(require 'flymake)

;; GUIの警告は表示しない
(setq flymake-gui-warnings-enabled nil)

;; 全てのファイルで flymakeを有効化
(add-hook 'find-file-hook 'flymake-find-file-hook)

;; M-p/M-n で警告/エラー行の移動
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)

;; error alert
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;;pytnon-mode 
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map "\"" 'electric-pair)
            (define-key python-mode-map "\'" 'electric-pair)
            (define-key python-mode-map "(" 'electric-pair)
            (define-key python-mode-map "[" 'electric-pair)
            (define-key python-mode-map "{" 'electric-pair)))
(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;; package.el
(when (require 'package nil t)
;; パッケージリポジトリにMarmaladeを追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;; インストールしたパッケージにロードパスを通してロードする
  (package-initialize))

;;; helm
(add-to-list 'load-path "~/your-path/helm")
(require 'helm-config)
(helm-mode 1)

;; auto-comp not 
(custom-set-variables '(helm-ff-auto-update-initial-value nil))
;; mini baffer C-h is back SPC
(define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
;; TAB
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action)

;;global-map
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c i")   'helm-imenu)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)

;;helm-ls-git
(require 'helm-ls-git)
(global-set-key (kbd "C-<f6>") 'helm-ls-git-ls)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

;mmm-mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
(mmm-add-classes
    '((html-php
    :submode php-mode
    :front "<\\?\\(php\\)?"
    :back "\\?>")))
    (add-to-list 'auto-mode-alist '("\\.php?\\'" . xml-mode))


;;auto-revert-mode
(global-auto-revert-mode 1)


;; ;;now-line-hilight
;;  (defface hlline-face
;;    '((((class color)
;;        (background dark))
;;       (:background "dark slate gray"))
;;      (((class color)
;;        (background light))
;;       (:background  "#F0F8FF"))
;;      (t
;;       ()))
;;   "*Face used by hl-line.")
;;  (setq hl-line-face 'hlline-face)
;;  (global-hl-line-mode)


;;emacs_nav
(setq load-path (cons "~/.emacs.d/elisp/emacs-nav-49" load-path))
(require 'nav)
;; ￥to \
(define-key global-map [?¥] [?\\])

