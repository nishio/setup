;; -*- coding: utf-8 -*-
;; インデントにタブを使うな。これはバッファローカル変数なのでデフォルト値をここでセットしておく。
(setq-default indent-tabs-mode nil)

;; 改行時に自動的にtrailing spaceを削る
(defun remove-trailing-space-then-newline ()
  (interactive "*")
  (delete-horizontal-space t)
  (newline))

(global-set-key "\C-m" 'remove-trailing-space-then-newline)

;; 行末の空白をめだたせる M-x delete-trailing-whitespaceで削除出来る
(when
    (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))

;;; 列数の表示
(column-number-mode 1)

;;; シンボリックリンクの読み込みを許可
(setq vc-follow-symlinks t)

;;リージョンを[delete][BS]で削除
(delete-selection-mode 1)

;;対応する括弧に色をつける
(require 'paren)
(show-paren-mode 1)

;; HOMEとENDでバッファ先頭とバッファ末尾
;; 元々は行頭・行末だったが、それはC-a,C-eでやってるので必要ない。
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)


;; 文字数カウント関数
(defun count-char-region (start end)
  (interactive "r")
  (save-excursion
    (save-restriction
      (let ((lf-num 0))	  ;;改行文字の個数を初期化している。
        (goto-char start) ;;指定領域の先頭に行く。
        (while (re-search-forward "[\n\C-m]" end t) ;;改行文字のカウント
          (setq lf-num (+ 1 lf-num))) ;;(つまり、 search できる度に 1 足す)
        (message "%d 文字 (除改行文字) : %d 行 : %d 文字 (含改行文字)"
                 (- end start lf-num) (count-lines start end) (- end start))
        ))))

;;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

;; JSのインデントを2スペースにする
(setq js-indent-level 2)

;;
;; 選択範囲をハイライトする
(setq transient-mark-mode t)

;;
;; 行番号へ飛ぶ
(global-set-key "\C-l" 'goto-line)

;; ターミナルの時の設定
(if (not window-system)
    (progn
      ;; C-zはsuspend-frameに割り当てられていたが、C-x C-zでもOKなのでこちらはundoにした
      (global-set-key "\C-z" 'undo)
      ;; http://unix.stackexchange.com/questions/47312/control-and-up-down-keys-in-terminal-for-use-by-emacs
      ;; ターミナルへは「文字」しか送信できない。文字にマッピングされていない「キー」は
      ;; エスケープシーケンスとして送ることになる。手元の端末エミュレータの設定で、
      ;; C-downなどがどういうエスケープシーケンスで送られているか確認してそれを設定する
      (define-key input-decode-map "\e[1;5A" [C-up])
      (define-key input-decode-map "\e[1;5B" [C-down])))

;;
;; carbonEmacsのときだけの設定
(if (eq window-system 'mac)
    (progn
      ;; 元々iconify-or-deiconify-frameに割り当てられていたが、要らないのでundoにした
      (global-set-key "\C-z" 'undo)
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
;; TODO: ~/.emacs.d/pluginsに移動する
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

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(set-frame-parameter nil 'fullscreen 'fullboth)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
;(require 'yasnippet)
;(setq yas-snippet-dirs
;      '("~/.emacs.d/snippets"            ;; personal snippets
;        "~/.emacs.d/plugins/yasnippet/snippets"    ;; the default collection
;        ))
;(yas-global-mode 1)

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
(add-to-list 'load-path "~/.emacs.d/plugins/howm-1.4.0/")
(setq howm-menu-lang 'ja)
(require 'howm)

(defun my-save-and-kill-buffer ()
  (interactive)
  (save-buffer)
  (kill-buffer nil))

;;(global-set-key "\C-c\C-c" 'my-save-and-kill-buffer)
;;howm メモだけに適用したければ, こうかな → 2ch2:415
(define-key howm-mode-map "\C-c\C-c" 'my-save-and-kill-buffer)

(add-to-list 'auto-mode-alist (cons ".howm$" 'howm-mode))

(if (eq window-system 'mac)
    (server-start))

; TODO
;(require 'gtags)

;;
;; rst-mode
(require 'rst)
(setq auto-mode-alist
      (append '(
		("\\.rst$" . rst-mode)
		) auto-mode-alist))

;; cygwinがC-=を掴んでしまうので変更（C-aはScreenが掴んでしまう）
(add-hook 'rst-mode-hook '(lambda () (local-set-key "\C-c\C-ca" 'rst-adjust)))

;; review-mode
(require 'review-mode)

;; 背景が黒い場合はこうしないと見出しが見づらい
(setq frame-background-mode 'dark)
;; 全部スペースでインデントしましょう
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; flymake
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.js\\'" flymake-simple-make-init))

(add-hook 'java-mode-hook
          '(lambda ()
             (flymake-mode)))

;; markdown-mode
;(require 'markdown-mode)
;(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
