;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Jason Chao"
      user-mail-address "jason@chao.com")

;;(setq doom-theme 'doom-vibrant)
;;(setq doom-theme 'doom-zenburn)
(setq doom-theme 'modus-operandi-tinted) ;;light theme
;;(setq doom-theme 'modus-vivendi-tinted) ;;dark theme
;;(setq doom-theme 'doom-one-light)
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

(pushnew! initial-frame-alist '(width . 140) '(height . 220))
;;(add-hook! 'window-setup-hook #'toggle-frame-fullscreen)

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

;;复制粘贴等，保持与系统习惯一致
(global-set-key (kbd "s-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-z") 'undo) ;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-x") 'kill-region) ;对应Windows上面的Ctrol-x 剪切
;;调用常用的命令或函数
(global-set-key (kbd "C-s") 'consult-line) ;;同“SPC s s”，类似于swiper的搜索方式
(global-set-key (kbd "<f12>") 'org-roam-capture) ;;打开org-roam捕捉模板
(global-set-key (kbd "<f7>") 'org-tags-view) ;;按tag筛选内容

(setq-default
 delete-by-moving-to-trash t        ; 将文件删除到回收站
 window-combination-resize t        ; 从其他窗口获取新窗口的大小
 x-stretch-cursor t                 ; 将光标拉伸到字形宽度
 )

(setq! undo-limit 104857600         ; 重置撤销限制到 100 MiB
       ;;auto-save-default t          ; 没有人喜欢丢失工作，我也是如此
       truncate-string-ellipsis "…" ; Unicode 省略号相比 ascii 更好
                                    ; 同时节省 /宝贵的/ 空间
       password-cache-expiry nil    ; 我能信任我的电脑 ... 或不能?
       ; scroll-preserve-screen-position 'always
                                    ; 不要让 `点' (光标) 跳来跳去
       scroll-margin 2              ; 适当保持一点点边距
       gc-cons-threshold 1073741824
       read-process-output-max 1048576
       )
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

(after! org (setq org-directory "~/Dropbox/Org-Notes/"))

(after! org (add-hook 'org-mode-hook
          (lambda ()
            (variable-pitch-mode 1)
            visual-line-mode))
;;
(setq org-hide-emphasis-markers t
      org-fontify-done-headline t
      org-odd-levels-only t
      ;;org-hide-leading-stars t
      org-log-done 'time
      org-pretty-entities t))
;;更改层级列表的样式
(after! org (setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a."))))

(after! org (setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "DELEGATED(e!)" "|" "DONE(d@/!)" "CANCELED(c@/!)"))))

(after! org (setq org-agenda-files
      (quote ("~/Dropbox/Org-Notes/" "~/Dropbox/Org-Notes/GTD/" "~/Dropbox/Org-Notes/Roam/projects/"))))
;;设置默认的视图模式，doom默认为week视图，此配置暂时屏蔽
;;(setq org-agenda-span 'week)
;;(setq org-agenda-span 'day)

(after! org (setq org-agenda-time-grid (quote ((daily today require-timed)
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
                                   ))))

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
(after! org (setq org-agenda-include-diary t))
(after! org (setq org-agenda-diary-file "~/Dropbox/Org-Notes/personal/mydiary"))
(after! org (setq diary-file "~/Dropbox/Org-Notes/personal/mydiary"))

(after! org (add-to-list 'org-modules 'org-habit t))
(after! org (setq org-habit-graph-column t))

(defun newday ()
  (interactive)
  (progn
    (find-file "~/Dropbox/Org-Notes/everyday.org")
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
      '(("t" "TASK" entry (file+headline "GTD/task.org" "Tasks")
         "* TODO %i%? [/] :@work: \n %U\n")
        ;;("p" "PROJECT" entry (file "GTD/project.org")
        ;; "* STARTUP %i%? [%] :PROJECT:@work: \n created on %U\n")
        ("c" "CAPTURE" entry (file "capture.org")
         "* %^{Title} :IDEA:%^{Tags}: \n created on %T\n From: %a\n")
        ("m" "MEETING" entry (file+headline "GTD/meeting.org" "Meetings")
         "* TODO %i%? :MEETING:@work: \n created on %U\n")
        ("w" "WORKLOG" entry
         (file+function "everyday.org"
                        my-org-goto-last-worklog-headline)
         "* %^{Title} :@work:%^{Tags}: \n%T")
        ("l" "LIFELOG" entry
         (file+function "everyday.org"
                        my-org-goto-last-lifelog-headline)
         "* %^{Title} :@life:%^{Tags}: \n%T")
        ("e" "EVENT" entry
         (file+function "everyday.org"
                        my-org-goto-last-event-headline)
         "* %^{Title} \n%T"))))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
    (setq org-modern-list '((?+ . "➤")
                               (?- . "–")
                               (?* . "•"))
             org-modern-star '("Ⓐ" "Ⓑ" "Ⓒ" "Ⓓ" "Ⓔ" "Ⓕ" "Ⓖ" "Ⓗ" "Ⓘ" "Ⓙ" "Ⓚ" "Ⓛ" "Ⓜ")
             org-modern-table nil
             org-modern-tag nil)
    ;;(:hook-into org-mode)
    ;; (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
    )

(use-package! org-appear
  :after org
  :config
  (setq org-appear-autolinks t)
  (setq org-appear-trigger 'manual)
  (add-hook 'org-mode-hook (lambda ()
                           (add-hook 'evil-insert-state-entry-hook
                                     #'org-appear-manual-start
                                     nil
                                     t)
                           (add-hook 'evil-insert-state-exit-hook
                                     #'org-appear-manual-stop
                                     nil
                                     t)))
  ;; (setq org-link-descriptive nil)

  (add-hook 'org-mode-hook 'org-appear-mode))

(after! org-download
  (add-hook 'org-mode-hook 'org-download-enable)
  (setq org-download-image-dir ("~/Dropbox/Org-Notes/images"))
  (setq org-download-screenshot-method 'screencapture)
  (setq org-download-abbreviate-filename-function 'expand-file-name)
  (setq org-download-timestamp "%Y%m%d%H%M%S")
  (setq org-download-display-inline-images nil)
  (setq org-download-heading-lvl nil)
  (setq org-download-annotate-function (lambda (_link) ""))
  (setq org-download-image-attr-list '("#+NAME: fig: "
                                       "#+CAPTION: "
                                       "#+ATTR_ORG: :width 500px"
                                       "#+ATTR_LATEX: :width 10cm :placement [!htpb]"
                                       "#+ATTR_HTML: :width 600px"))
  ;; (setq org-download-screenshot-basename ".png")
  )

(defun org-export-docx ()
    "Convert org to docx."
    (interactive)
    (let ((docx-file (concat (file-name-sans-extension (buffer-file-name)) ".docx"))
          (template-file ("~/.doom.d/template/template.docx")))
      (shell-command (format "pandoc %s -o %s --reference-doc=%s" (buffer-file-name) docx-file template-file))
      (message "Convert finish: %s" docx-file)))

(defun +org-insert-file-link ()
  "Insert a file link.  At the prompt, enter the filename."
  (interactive)
  (insert (format "[[%s]]" (org-link-complete-file))))
;;
(map! :after org
      :map org-mode-map
      :localleader
      "l f" #'+org-insert-file-link)

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.
;;增强history
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump) ;;跳转到buffer所在的目录
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file))) ;;peep-dired 预览文件内容

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
;;
(setq dired-dwim-target t) ;;打开两个窗口，在一个窗口复制或移动文件时直接定位到另一个窗口

;;(require 'ivy-rich)
;;(ivy-rich-mode 1)
;;(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

;;(require 'find-file-in-project)
;;(ivy-mode 1)
;;(setq ffip-project-root "~/Org-Notes")

(setq eros-eval-result-prefix "⟹ ") ; default =>

;;(setq yas-triggers-in-field t)

(sp-local-pair
 '(org-mode)
 "<<" ">>"
 :actions '(insert))

(after! avy
  ;; home row priorities: 8 6 4 5 - - 1 2 3 7
  (setq avy-keys '(?n ?e ?i ?s ?t ?r ?i ?a)))

(use-package emojify
  :hook (after-init . global-emojify-mode))

(use-package! pyim
  :config
  (require 'pyim-basedict)
  (require 'pyim-cregexp-utils)
  (pyim-basedict-enable)
  ;; (setq default-input-method "pyim")

  ;; 如果使用 popup page tooltip, 就需要加载 popup 包。
  ;; (require 'popup nil t)
  ;; (setq pyim-page-tooltip 'popup)

  ;; 如果使用 pyim-dregcache dcache 后端，就需要加载 pyim-dregcache 包。
  ;; (require 'pyim-dregcache)
  ;; (setq pyim-dcache-backend 'pyim-dregcache)



  ;; 显示5个候选词。
  (setq pyim-page-length 5)

  ;; 金手指设置，可以将光标处的编码，比如：拼音字符串，转换为中文。
  ;; (global-set-key (kbd "M-j") 'pyim-convert-string-at-point)

  ;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
  (define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)

  ;; 我使用全拼
  (pyim-default-scheme 'quanpin)
  ;; (pyim-default-scheme 'wubi)
  ;; (pyim-default-scheme 'cangjie)

  ;; 我使用云拼音
  ;; (setq pyim-cloudim 'baidu)

  ;; pyim 探针设置
  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  ;; (setq-default pyim-english-input-switch-functions
  ;;               '(pyim-probe-dynamic-english
  ;;                 pyim-probe-isearch-mode
  ;;                 pyim-probe-program-mode
  ;;                 pyim-probe-org-structure-template))

  ;; (setq-default pyim-punctuation-half-width-functions
  ;;               '(pyim-probe-punctuation-line-beginning
  ;;                 pyim-probe-punctuation-after-punctuation))

  ;; 开启代码搜索中文功能（比如拼音，五笔码等）
  (pyim-isearch-mode 1)
  ;; 让 vertico, selectrum 等补全框架，通过 orderless 支持拼音搜索候选项功能。
  (defun my-orderless-regexp (orig-func component)
    (let ((result (funcall orig-func component)))
      (pyim-cregexp-build result)))
  ;; 以下解决 在vertico 搜索时按 C-n C-p 卡顿的问题
  (defun xyu/pyim-advice-add ()
    (advice-add 'orderless-regexp :around #'my-orderless-regexp))

  (defun xyu/pyim-advice-remove (&optional n)
    (advice-remove 'orderless-regexp #'my-orderless-regexp))

  (advice-add  #'vertico-next :before #'xyu/pyim-advice-remove)
  (advice-add  #'vertico-previous :before #'xyu/pyim-advice-remove)
  (advice-add  'abort-recursive-edit :before #'xyu/pyim-advice-add)
  (advice-add  'abort-minibuffers :before #'xyu/pyim-advice-add)
  (advice-add  'exit-minibuffer :before #'xyu/pyim-advice-add)
  (xyu/pyim-advice-add)   ;; 默认开启
  )

;; Enable the www ligature in every possible major mode
;;(ligature-set-ligatures 't '("www"))
;;
;;;; Enable ligatures in programming modes
;;(ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
;;                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
;;                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
;;                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
;;                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
;;                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
;;                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
;;                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
;;                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
;;                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
;;
;;(global-ligature-mode 't)
;;

(use-package! sis
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :config
  ;; For MacOS
  ;; (sis-ism-lazyman-config

  ;;  ;; English input source may be: "ABC", "US" or another one.
  ;;  ;; "com.apple.keylayout.ABC"
  ;;  "com.apple.keylayout.US"

  ;;  ;; Other language input source: "rime", "sogou" or another one.
  ;;  ;; "im.rime.inputmethod.Squirrel.Rime"
  ;;  "com.sogou.inputmethod.sogou.pinyin")
 ;; (sis-ism-lazyman-config "1" "2" 'fcitx5)
 (sis-ism-lazyman-config
 "com.apple.keylayout.ABC"
 "com.sogou.inputmethod.sogou.pinyin")

  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )

(beacon-mode 1)

;;from: https://github.com/tecosaur/emacs-config/blob/master/config.org
(use-package! beancount
  :mode ("\\.beancount\\'" . beancount-mode)
  :init
  (after! all-the-icons
    (add-to-list 'all-the-icons-icon-alist
                 '("\\.beancount\\'" all-the-icons-material "attach_money" :face all-the-icons-lblue))
    (add-to-list 'all-the-icons-mode-icon-alist
                 '(beancount-mode all-the-icons-material "attach_money" :face all-the-icons-lblue)))
  :config
  (setq beancount-electric-currency t)
  (defun beancount-bal ()
    "Run bean-report bal."
    (interactive)
    (let ((compilation-read-command nil))
      (beancount--run "bean-report"
                      (file-relative-name buffer-file-name) "bal")))
  (map! :map beancount-mode-map
        :n "TAB" #'beancount-align-to-previous-number
        :i "RET" (cmd! (newline-and-indent) (beancount-align-to-previous-number))))

(use-package! keyfreq
  :config
   (keyfreq-mode 1)
   (keyfreq-autosave-mode 1))

(setq org-use-fast-tag-selection t)
(defun eh-org-fast-tag-selection (&rest args)
  (let* ((current-tags (cl-copy-list (car args)))
         (n (length current-tags))
         (max 5)
         (prompt (if (> n 0)
                     (format "Tag (%s%s): "
                             (mapconcat #'identity
                                        (cl-subseq current-tags 0 (min n max))
                                        ", ")
                             (if (> n max)
                                 " ..."
                               ""))
                   "Tag: "))
         (crm-separator"[ 	]*[:,][ 	]*")
         (tgs (completing-read-multiple
               prompt (mapcar
                       (lambda (x)
                         (if (member (car x) current-tags)
                             (cons (propertize (car x) 'face '(:box t)) (cdr x))
                           x))
                       (org-get-buffer-tags)))))
    (dolist (tg (delete-dups (remove "" tgs)))
      (when (string-match "\\S-" tg)
        (if (member tg current-tags)
	    (setq current-tags (delete tg current-tags))
	  (push tg current-tags))))
    (org-make-tag-string current-tags)))
(advice-add 'org-fast-tag-selection :override #'eh-org-fast-tag-selection)

(add-to-list 'load-path "/Users/qianli/AI/mind-wave")
(require 'mind-wave)
(setq mind-wave-auto-change-title nil) ;;关闭自动生成title的功能
