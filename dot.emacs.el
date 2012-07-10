;; インデントにタブを使うな。これはバッファローカル変数なのでデフォルト値をここでセットしておく。
(setq-default indent-tabs-mode nil)

;; 改行時に自動的にtrailing spaceを削る
(global-set-key "\C-m" 'newline-and-indent)

;; 行末の空白をめだたせる M-x delete-trailing-whitespaceで削除出来る
(when
    (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))

;; JSのインデントを2スペースにする
(setq js-indent-level 2)

;;
;; 選択範囲をハイライトする
(setq transient-mark-mode t)

;;
;; 行番号へ飛ぶ
(global-set-key "\C-l" 'goto-line)

;;
;; carbonEmacsのときだけの設定
(if (eq window-system 'mac)
    (progn
      ;; Cmd-WでコピーしているとFirefoxに貼付けた後とかで
      ;; コピーしようとして間違えて閉じたりして悲しいので
      ;; M-c (デフォルトはcapitalize-word)に割り当てる
      ;; M-v (scroll-down)もついでに変更。
      (global-set-key "\M-c" 'kill-ring-save)
      (global-set-key "\M-v" 'yank)
      ;; C-x C-c(save-buffers-kill-emacs)で終了してしまうと悲しいので
      ;; C-x #(server-edit)またはC-x k(kill-buffer)をするように変更
      (define-key ctl-x-map "\C-c" 'server-edit-kill-buffer)))


(defun server-edit-kill-buffer ()
  "Kill buffer without client, or release server-edited buffer with client."
  (interactive)
  (if (and server-process
           (not (memq (process-status server-process) '(signal exit)))
           server-buffer-clients)
      (server-edit)
    (kill-buffer (current-buffer))))

;; .emacs.dにパスを通す
;; 細々した*.elはここに置く
(add-to-list 'load-path "~/.emacs.d")


;; フォントを大きく、背景に薄い色を付けて目に配慮、サイズは最大化
(if (eq window-system 'mac) ; carbonEmacsのときだけ
    (progn
      (require 'carbon-font)
      (setq initial-frame-alist ; 最初に開いたときの設定
	    '((font . "-*-*-medium-r-normal--16-*-*-*-*-*-fontset-osaka")))

      (set-frame-parameter nil 'fullscreen 'fullboth)

      ; 追加で開いたときの設定。上に同じ。
      (setq default-frame-alist initial-frame-alist)))

;;
;; 最大化
(defun mac-toggle-max-window ()
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (set-frame-parameter nil 'fullscreen nil)
    (set-frame-parameter nil 'fullscreen 'fullboth)))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(safe-local-variable-values (quote ((enoding . utf-8) (encoding . utf-8))))
 '(tool-bar-mode nil)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color)) (:background "DarkRed"))))
 '(flymake-warnline ((((class color)) (:background "DarkGreen")))))



(if window-system (progn
   (set-background-color "Black")
   (set-foreground-color "LightGreen")
   (set-cursor-color "Green")
;   (set-frame-parameter nil 'alpha 80)
   ))

;; from
;; http://coderepos.org/share/browser/dotfiles/emacs/tokuhirom-emacs?rev=589
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 前のウィンドウへ、次のウィンドウへ、の移動が楽になる
;; from GNU Emacs 拡張ガイド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun other-window-backward (&optional n)
  "Select Nth previous window."
  (interactive "P")
  (other-window (- (prefix-numeric-value n))))
(global-set-key "\C-x\C-p" 'other-window-backward)
(global-set-key "\C-x\C-n" 'other-window)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Action Script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; via http://blog.pettomato.com/content/site-lisp/.emacs
(defvar running-on-x (eq window-system 'x))
(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)
;; Activate actionscript-mode for any files ending in .as
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
;; Load our actionscript-mode extensions.
(eval-after-load "actionscript-mode" '(load "as-config"))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)

;;;; http://d.hatena.ne.jp/antipop/20080321/1206090430
;; 複数のディレクトリからスニペットを読み込む。
;; yasnippetのsnippetを置いてあるディレクトリ
(setq yas/root-directory (expand-file-name "~/.emacs.d/yasnippet/snippets"))

;; 自分用スニペットディレクトリ(リストで複数指定可)
(defvar my-snippet-directories
  (list (expand-file-name "~/.emacs.d/yasnippet/coderepos_common")
;        (expand-file-name "~/.emacs.d/yasnippet/coderepos_nishio")
	(expand-file-name "~/.emacs.d/yasnippet/spark")
        (expand-file-name "~/.emacs.d/yasnippet/private")
        (expand-file-name "~/cur/topcoder/tcutils/yasnippet")
	))

;; yasnippet公式提供のものと、自分用カスタマイズスニペットをロード同名
;; のスニペットが複数ある場合、あとから読みこんだ自分用のものが優先され
;; る。また、スニペットを変更、追加した場合、このコマンドを実行すること
;; で、変更・追加が反映される。

(defun yas/load-all-directories ()
  (interactive)
  (yas/reload-all)
  (mapc 'yas/load-directory-1 my-snippet-directories))

;; スニペットディレクトリではバックアップを作らない
(add-hook
 'before-save-hook
 (lambda ()
   (let ((snippet-dir "yasnippet/")
	 (buf-dir (file-name-directory (or buffer-file-name " "))))
     (when (string-match snippet-dir buf-dir)
       (set (make-local-variable 'make-backup-files) nil))
     (when (string-match "Dropbox" buf-dir)
       (set (make-local-variable 'make-backup-files) nil))
     (when (string-match "howm" buf-dir)
       (set (make-local-variable 'make-backup-files) nil))
     (when (string-match ".howm" buffer-file-name)
       (set (make-local-variable 'make-backup-files) nil))

     )))


;; yasnippet初期化
(yas/initialize)
(yas/load-all-directories)

 (setq italk-server "192.168.11.2")


(require 'flymake)
(defun flymake-cc-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list "g++" (list
		 "-Wall" "-W" "-Wformat=2" "-Wcast-qual" "-Wcast-align"
		 "-Wwrite-strings" "-Wconversion" "-Wfloat-equal" "-Wpointer-arith"
		 "-I/opt/local/include/"
		 local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(add-hook 'c++-mode-hook
	  '(lambda () (flymake-mode t)))



;; howm
(setq howm-menu-lang 'ja)
(require 'howm)

(defun my-save-and-kill-buffer ()
  (interactive)
  (save-buffer)
  (kill-buffer nil))

;;(global-set-key "\C-c\C-c" 'my-save-and-kill-buffer)
;;howm メモだけに適用したければ, こうかな → 2ch2:415
 (define-key howm-mode-map "\C-c\C-c" 'my-save-and-kill-buffer)


(add-to-list 'load-path "~/.emacs.d/taskpaper/branches/nishio")
(require 'taskpaper)

(defun taskpaper-and-howm-mode ()
  (taskpaper-mode) ; major-mode
  (howm-mode) ; minor-mode
)

(add-to-list 'auto-mode-alist (cons ".howm$" 'howm-mode))
(add-to-list 'auto-mode-alist (cons "todo.howm$" 'taskpaper-and-howm-mode))
(add-to-list 'auto-mode-alist (cons "ituka.howm$" 'taskpaper-and-howm-mode))
(add-to-list 'auto-mode-alist (cons "activity.howm$" 'taskpaper-and-howm-mode))
(add-to-list 'auto-mode-alist (cons "projects.howm$" 'taskpaper-and-howm-mode))

(server-start)

(require 'gtags)

;; tualeg.el
(load "/opt/local/share/emacs/site-lisp/tuareg.el")

;;
;; rst-mode
(require 'rst)
(setq auto-mode-alist
      (append '(
		("\\.rst$" . rst-mode)
		) auto-mode-alist))

;; 背景が黒い場合はこうしないと見出しが見づらい
(setq frame-background-mode 'dark)
;; 全部スペースでインデントしましょう
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;;
;; alloy-mode
(require 'alloy-mode)
(setq auto-mode-alist
      (append '(
		("\\.als$" . alloy-mode)
		) auto-mode-alist))

;; flymake
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.js\\'" flymake-simple-make-init))

(add-hook 'java-mode-hook
          '(lambda ()
             (flymake-mode)))


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)