;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Jason Chao"
      user-mail-address "jason@chao.com")

;;(setq doom-theme 'doom-vibrant)
(setq doom-theme 'doom-zenburn)
(setq display-line-numbers-type t) ;;行号
(global-visual-line-mode 1) ;;换行
;;美化buffer name
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")
;;字体
;;(set-face-attribute 'default nil :height 160)
;;西文字体
(setq doom-font (font-spec :family "Source Code Pro" :size 15)
      doom-big-font (font-spec :family "Source Code Pro" :size 30)
      doom-variable-pitch-font (font-spec :family "Source Code Variable" :size 15)
      doom-unicode-font (font-spec :family "JuliaMono")
      doom-serif-font (font-spec :family "TeX Gyre Cursor")
      )
;;中文字体
;;(defun xyu/doom-init-ui-misc()
;;  (menu-bar-mode -1)               ;; disable menu-bar
;; (setq-default cursor-type 'box)  ;; set box style cursor
;;  (blink-cursor-mode -1)           ;; cursor not blink
 ;; <<doom-dashboard-layout>>
;;  (if (display-graphic-p)
;;      (progn
        ;; NOTE: ONLY GUI
        ;; set font
;;        (dolist (charset '(kana han symbol cjk-misc bopomofo gb18030))
;;          (set-fontset-font (frame-parameter nil 'font) charset
;;                            (font-spec :family "Source Han Mono")))
;;        (appendq! face-font-rescale-alist
;;                  '(("Source Han Mono" . 1.2)
;;                    ))
  ;;      <<doom-image-banner>>
        ;; random banner image from bing.com, NOTE: https://emacs-china.org/t/topic/264/33
;;        )
;;    (progn
      ;; NOTE: ONLY TUI
   ;;   <<doom-ascii-banner>>
;;      )))
;;(add-hook! 'doom-init-ui-hook #'xyu/doom-init-ui-misc)

;;(pushnew! initial-frame-alist '(width . 220) '(height . 80))
(add-hook! 'window-setup-hook #'toggle-frame-fullscreen)

;;默认修改中的文件名颜色是红色，这里改为orange
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))
;;将modeline的高度从默认的25改为45
(setq doom-modeline-height 45)
;; 当文件不是utf编码时才显示提示，否则隐藏
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
;;设置modeline中展示的内容
(after! doom-modeline
  (custom-set-variables '(doom-modeline-buffer-file-name-style 'relative-to-project)
                        '(doom-modeline-major-mode-icon t)
                        '(doom-modeline-modal-icon nil))
  (nyan-mode t)) ;;彩虹猫
;; open dashboard
;;(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)

(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-x") 'kill-region) ;对应Windows上面的Ctrol-x 剪切

(setq auto-save-visited-mode t)
(auto-save-visited-mode +1)
(setq auto-revert-use-notify nil)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; 方向
      "<left>"   #'evil-window-left
      "<down>"   #'evil-window-down
      "<up>"     #'evil-window-up
      "<right>"  #'evil-window-right
      ;; 交换窗口
      "C-<left>"   #'+evil/window-move-left
      "C-<down>"   #'+evil/window-move-down
      "C-<up>"     #'+evil/window-move-up
      "C-<right>"  #'+evil/window-move-right
      )

(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks" "L" #'list-bookmarks
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

(after! org (setq org-directory "~/Org-Notes/"))

(add-hook 'org-mode-hook
          (lambda ()
            (variable-pitch-mode 1)
            visual-line-mode))
;;
(setq org-hide-emphasis-markers t
      org-fontify-done-headline t
      org-odd-levels-only t
      ;;org-hide-leading-stars t
      org-log-done 'time
      org-pretty-entities t)
;;更改层级列表的样式
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a.")))

(after! org (setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "DELEGATED(e!)" "|" "DONE(d@/!)" "CANCELED(c@/!)"))))

(after! org (setq org-agenda-files
      (quote ("~/Org-Notes/" "~/Org-Notes/work/" "~/Org-Notes/personal/"))))
;;设置默认的视图模式，doom默认为week视图，此配置暂时屏蔽
;;(setq org-agenda-span 'week)
;;(setq org-agenda-span 'day)

(setq org-agenda-time-grid (quote ((daily today require-timed)
                                   (300
                                    600
                                    900
                                    1200
                                    1500
                                    1800
                                    2100
                                    2400)
                                   "......"
                                   "-----------------------------------------------------"
                                   )))

;;设置location，以便计算日出日落时间
(setq calendar-longitude 116.9962)
(setq calendar-latitude 39.91)
;;计算sunrise和sunset的时间
(defun diary-sunrise ()
  (let ((dss (diary-sunrise-sunset)))
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ",")
      (buffer-substring (point-min) (match-beginning 0)))))

(defun diary-sunset ()
  (let ((dss (diary-sunrise-sunset))
        start end)
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ", ")
      (setq start (match-end 0))
      (search-forward " at")
      (setq end (match-beginning 0))
      (goto-char start)
      (capitalize-word 1)
      (buffer-substring start end))))
;;diary文件位置
(setq org-agenda-include-diary t)
(setq org-agenda-diary-file "~/Org-Notes/personal/mydiary")
(setq diary-file "~/Org-Notes/personal/mydiary")

(add-to-list 'org-modules 'org-habit t)
(setq org-habit-graph-column t)

;;自定义函数，用于定位everyday.org中的几个关键heading的位置
(defun my-org-goto-last-worklog-headline ()
  "Move point to the last headline in file matching \"* WORKLOG\"."
  (end-of-buffer)
  (re-search-backward "\\* WORKLOG"))

(defun my-org-goto-last-event-headline ()
  "Move point to the last headline in file matching \"* EVENTS\"."
  (end-of-buffer)
  (re-search-backward "\\* EVENTS"))

(defun my-org-goto-last-lifelog-headline ()
  "Move point to the last headline in file matching \"* LIFELOG\"."
  (end-of-buffer)
  (re-search-backward "\\* LIFELOG"))

;; org-capture模板
(after! org (setq org-capture-templates
      '(("t" "TASK" entry (file+headline "work/task.org" "Tasks")
         "* TODO %i%? [/] :@work: \n %U\n From: %a\n")
        ("n" "NOTE" entry (file "note.org")
         "* %i%? :NOTE: \n created on %T\n From: %a\n")
        ("m" "MEETING" entry (file+headline "work/meeting.org" "Meetings")
         "* TODO %i%? :MEETING:@work: \n created on %U\n")
        ("w" "WORKLOG" entry
         (file+function "everyday.org"
                        my-org-goto-last-worklog-headline)
         "* %i%? :@work: \n%T")
        ("l" "LIFELOG" entry
         (file+function "everyday.org"
                        my-org-goto-last-lifelog-headline)
         "* %i%? :@life: \n%T")
        ("e" "EVENT" entry
         (file+function "everyday.org"
                        my-org-goto-last-event-headline)
         "* %i%? \n%T"))))

(defun newday ()
  (interactive)
  (progn
    (find-file "~/Org-Notes/everyday.org")
    (goto-char (point-max))
    (insert "*" ?\s (format-time-string "%Y-%m-%d %A") ?\n
            "** PLAN\n"
            "** WORKLOG\n"
            "** LIFELOG\n"
            "** EVENTS\n"
            "** REVIEW\n"
            "*** 今天最大的成果什么？ \n"
            "*** 今天有什么惊喜？ \n"
            "*** 今天有什么需要改进的地方？ \n"
            )))

(defun +org-insert-file-link ()
  "Insert a file link.  At the prompt, enter the filename."
  (interactive)
  (insert (format "[[%s]]" (org-link-complete-file))))
;;
(map! :after org
      :map org-mode-map
      :localleader
      "l f" #'+org-insert-file-link)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
;;(setq dired-open-extensions '(("gif" . "sxiv")
;;                              ("jpg" . "sxiv")
;;                              ("png" . "sxiv")
;;                              ("mkv" . "mpv")
;;                              ("mp4" . "mpv")))
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(require 'ivy-rich)
(ivy-rich-mode 1)
(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

(require 'find-file-in-project)
(ivy-mode 1)
(setq ffip-project-root "~/Org-Notes")

(setq eros-eval-result-prefix "⟹ ") ; default =>

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.
;;增强history
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(setq yas-triggers-in-field t)

(sp-local-pair
 '(org-mode)
 "<<" ">>"
 :actions '(insert))

(after! avy
  ;; home row priorities: 8 6 4 5 - - 1 2 3 7
  (setq avy-keys '(?n ?e ?i ?s ?t ?r ?i ?a)))

(use-package emojify
  :hook (after-init . global-emojify-mode))
