
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
        (expand-file-name (concat user-emacs-directory path))))
      (add-to-list 'load-path default-directory)
      (if (fboundp 'nomal-top-level-add-subdirs-to-load-path)
          (nomal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

;; http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))

;; CocoaEmacs以外はメニューバーを非表示
(unless (eq window-system 'ns)
  (menu-bar-mode 0))

;; C-mにnweline-and-indentを割り当てる
(global-set-key (kbd "C-m") 'newline-and-indent)

;; C-tでウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; ファイルサイズを表示
(size-indication-mode t)

;; 時計を表示
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)

;; バッテリー残量を表示
(display-battery-mode t)

;; TABの表示幅。初期値は8
(setq-default tab-width 4)

;; auto-installの設定
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; redo+の設定
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-.") 'redo))

;; anything
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
	(anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
	(require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
	(descbinds-anything-install)))

;; auto-completeの設定
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
			   "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; color-moccurの設定
(when (require 'color-moccur nil t)
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(setq moccur-use-migemo t)))

;; moccur-editの編集
(require 'moccur-edit nil t)

;; perl-modeをcperl-modeのエイリアスにする
(defalias 'perl-mode 'cperl-mode)

;; perl-completionの設定
(defun perl-completion-hook ()
  (when (require 'perl-completion nil t)
	(perl-completion-mode t)
	(when (require 'auto-complete nil t)
	  (auto-complete-mode t)
	  (make-variable-buffer-local 'ac-sources)
	  (setq ac-sources
			'(ac-source-perl-completion)))))

(add-hook 'cperl-mode-hook 'perl-completion-hook)


;; setup package.el
(require 'package)
(add-to-list 'package-archives
			   '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; wgrepの設定
(require 'wgrep nil t)

;; 行番号を表示
(global-linum-mode t)
