;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jason Chao"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-vibrant)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org-Notes/")
;;
;; my Org-mode config
;;增加行间距
(add-hook 'org-mode-hook
        (lambda ()
        (kill-local-variable 'line-spacing) ;; 如果之前设置的 local 变量没有
           ;; 删除，可能会导致后面的设置无效。
      (setq-local default-text-properties
                '(line-spacing 0.25     ;; 必须两项组合，
                             line-height 1.45      ;; 才能起到效果。
                           ))))
;;设置全局快捷键调用capture
;;(define-key global-map "\C-cc" 'org-capture)
;;设置默认目录
;;(setq org-directory "~/Org-Notes/")
;;
;;设置全局缩进模式
;;(setq org-startup-indented t)
;;
;;--美化orgmode--
;;(require 'org-bullets)
;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;
;;(prelude-require-package 'org-bullets
  ;;           :custom
    ;;         (org-bullets-bullet-list '("◉" "☯" "○" "☯" "✸" "☯" "✿" "☯" "✜" "☯" "◆" "☯" "▶"))
      ;;       (org-ellipsis "⤵")
        ;;     :hook (org-mode . org-bullets-mode))
;;
(add-hook 'org-mode-hook
          (lambda ()
            (variable-pitch-mode 1)
            visual-line-mode))
;;
(setq org-hide-emphasis-markers t
      org-fontify-done-headline t
      org-odd-levels-only t
      ;;org-hide-leading-stars t
      org-pretty-entities t)

;;--END--
;;--设置TODO--
;;(t)代表快捷字母；!代表时间戳；@代表一个有时间戳的记录笔记
(after! org (setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "DELEGATED(e!)" "|" "DONE(d@/!)" "CANCELED(c@/!)"))))
;;
;;任务完成时，记录时间及log
(setq org-log-done 'note)
;;
;;设置优先级
;;;;C-c , 设置优先级；A, B, C，SPC删除优先级；S-Up/Down，升级或降级
;;--END--
;;设置默认的标签列表，在org文件中可以快速选择常用标签
(setq org-tag-alist '(("@office" . ?o) ("@home" . ?h) ("@trip" . ?t)))
;;
;;--设置日程文件--
;;;;C-c C-s schedule
;;;;C-c C-d deadline
;;;;C-c [ 直接将当前文件加入到列表中
;;;;. 跳到今天
;;;;r 刷新视图
;;;;tab 在其他窗口打开对应条目; return 在当前窗口打开对应条目
;;;;A 互动式切换视图
;;;;v d 切换日视图
;;;;v w 切换周视图
;;;;v m 切换月视图
;;;;j 跳转到指定日期
;;;;t 切换todo状态
;;;;: 设置tags
;;;;, 设置优先级
;;;;i 插入日记内容
;;;;q 退出视图
;;;;x 退出视图（完全）
;;;;C-x C-w 将视图导出为一个文件
;;;;C-c C-x C-c 在视图中开启column模式
;;--END--
;;(setq org-agenda-files
  ;;    (quote ("~/Dropbox/Org-Notes/everyday.org" "~/Dropbox/Org-Notes/work/meeting.org" "~/Dropbox/Org-Notes/work/task.org" "~/Dropbox/Org-Notes/work/project.org" "~/Dropbox/Org-Notes/personal/habit.org" "~/Dropbox/Org-Notes/work/worklog.org")))
(setq org-agenda-files
      (quote ("~/Org-Notes/" "~/Org-Notes/work/" "~/Org-Notes/personal/")))

;;(setq org-agenda-span 'week)
;;(setq org-agenda-span 'day)
;;
;;更改Agenda时间间隔为3小时一单元
;;---------------------------------------------
;;org-agenda-time-grid
;;--------------------------------------------
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
;;设置日记
(setq org-agenda-include-diary t)
(setq org-agenda-diary-file "~/Org-Notes/personal/mydiary") ;;2020-03-02 10:47:06
(setq diary-file "~/Org-Notes/personal/mydiary")
;;--END--
;;--设置capture模板--
;;(setq org-default-notes-file (concat org-directory "capture.org"))
;;(setq org-capture-templates
  ;;    '(("t" "TASK" entry (file+headline "work/task.org" "Tasks")
    ;;     "* TODO %?\n  %U\n From: %a\n" :clock-in t :clock-resume t)
      ;;  ("n" "NOTE" entry (file "note.org")
        ;; "* %? :NOTE:\n%U\n From: %a\n")
        ;;("w" "WORKLOG" entry (file+datetree "work/worklog.org")
;;         "* %?\n logged on %U\n %a\n")
       ;; ("l" "LIFELOG" entry (file+datetree "personal/lifelog.org")
  ;;       "* %?\n logged on %U\n %a\n")
;;        ("m" "MEETING" entry (file+headline "work/meeting.org" "Meetings")
  ;;       "* TODO %?\n logged on %U\n%a\n")))
;;--END--
;;--Drawer and Block--
;;;;C-c C-x d 插入drawer
;;;;C-c C-z Add a time-stamped note to the ‘LOGBOOK’ drawer
;;;;Block #+BEGIN’ . . . ‘#+END
;;--END--
;;设置habit
(add-to-list 'org-modules 'org-habit t)
(setq org-habit-graph-column t)
;;--项目相关--
;;;;使用[/]或[%]，统计项目相关联的任务完成情况
;;--END--
;; Org中插入图片
;;(setq org-download-method 'directory)
;;(require 'org-download)
;;(use-package! org-download)
;(setq org-download-method 'directory
      ;;org-download-image-dir (concat "img/"  (format-time-string "%Y") "/")
      ;;org-download-image-org-width 600
;;org-download-heading-lvl 1)
;;(setq-default org-download-heading-lvl nil)
;;(setq-default org-download-image-dir "./images")
;;时间
;;C-c . 插入时间
;;C-c ! 插入不活跃的时间
;;
;;everyday模板;capture模板
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
;;---------------------------------------
;;Basic configs
;;改键，将复制粘贴等动作统一为系统操作命令
(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-x") 'kill-region) ;;对应Windows上面的Ctrol-x 剪切
;;----Keycast Config------
;;(require 'keycast)
;;(keycast-mode t)
(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast--update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast " ")))
      (remove-hook 'pre-command-hook 'keycast--update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))
;;行号
;;(setq line-number-mode t)
;;(global-display-line-numbers-mode)
;;(setq display-line-numbers-width-start t)
;;(setq display-line-numbers-width 4)

;;设置默认换行
(global-visual-line-mode 1)
;;设置ivy-rich，可以显示命令的解释
(require 'ivy-rich)
(ivy-rich-mode 1)
(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
;;
;;Org-pomodoro
;;自动保存
(setq auto-save-visited-mode t)
(auto-save-visited-mode +1)
;;自动刷新buffer
;;（global-auto-revert-mode t）
(setq auto-revert-use-notify nil)
;;设置Emacs启动窗口大小(default Frame size)
;;(add-to-list 'default-frame-alist '(height . 24))
;;(add-to-list 'default-frame-alist '(width . 80))
(pushnew! initial-frame-alist '(width . 220) '(height . 80))
;;设置windows
(setq evil-vsplit-window-right t
      evil-split-window-below t)
;;设置日历中的日出日落时间
;; location
(setq calendar-longitude 116.9962)
(setq calendar-latitude 39.91)
;;Sunrise and Sunset
;;日出而作, 日落而息
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
;;绑定M-n和M-p，为半屏翻页
(defun previous-multilines ()
  "scroll down multiple lines"
  (interactive)
  (scroll-down (/ (window-body-height) 3)))


(defun next-multilines ()
  "scroll up multiple lines"
  (interactive)
  (scroll-up (/ (window-body-height) 3)))

;;(global-set-key "\M-n" 'next-multilines) ;;custom
;;(global-set-key "\M-p" 'previous-multilines) ;;custom
(global-set-key (kbd "<f5>") 'org-clock-in) ;;start a timer
(global-set-key (kbd "<f6>") 'org-clock-out) ;;stop a timer

;;Find file in project
(require 'find-file-in-project)
(ivy-mode 1)
(setq ffip-project-root "~/Org-Notes")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
