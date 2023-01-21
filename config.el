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

(after! org (setq org-directory "~/Org-Notes/"))

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
      (quote ("~/Org-Notes/" "~/Org-Notes/GTD/"))))
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
(after! org (setq org-agenda-diary-file "~/Org-Notes/personal/mydiary"))
(after! org (setq diary-file "~/Org-Notes/personal/mydiary"))

(after! org (add-to-list 'org-modules 'org-habit t))
(after! org (setq org-habit-graph-column t))

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
        ("p" "PROJECT" entry (file "GTD/project.org")
         "* STARTUP %i%? [%] :PROJECT:@work: \n created on %U\n")
        ("c" "CAPTURE" entry (file "capture.org")
         "* %i%? :IDEA: \n created on %T\n From: %a\n")
        ("m" "MEETING" entry (file+headline "GTD/meeting.org" "Meetings")
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

(after! org-download
  (add-hook 'org-mode-hook 'org-download-enable)
  (setq org-download-image-dir ("~/Org-Notes/images"))
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

(defun org-export-docx ()
    "Convert org to docx."
    (interactive)
    (let ((docx-file (concat (file-name-sans-extension (buffer-file-name)) ".docx"))
          (template-file ("~/.doom.d/template/template.docx")))
      (shell-command (format "pandoc %s -o %s --reference-doc=%s" (buffer-file-name) docx-file template-file))
      (message "Convert finish: %s" docx-file)))

(after! org-roam (setq org-roam-directory (file-truename "~/Org-Notes/Roam/")))
;;

;;设置timestamp
  (after! org-roam (add-hook 'org-mode-hook (lambda ()
                             (setq-local time-stamp-active t
                                         time-stamp-start "#\\+MODIFIED:[ \t]*"
                                         time-stamp-end "$"
                                         time-stamp-format "\[%Y-%m-%d %3a %H:%M\]")
                             (add-hook 'before-save-hook 'time-stamp nil 'local))))

(after! org-roam
  (add-hook 'org-roam-mode-hook 'turn-on-visual-line-mode)
  (add-hook 'org-roam-mode-hook 'word-wrap-whitespace-mode)

  (org-roam-db-autosync-mode)

  (setq org-roam-db-gc-threshold most-positive-fixnum)

  (setq org-roam-mode-sections '(org-roam-backlinks-section
                                 org-roam-reflinks-section
                                 org-roam-unlinked-references-section))

  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.25))))

(after! org-roam
  ;; Auto toggle org-roam-buffer.
  (defun xyu/org-roam-buffer-show (_)
    (if (and
         ;; Don't do anything if we're in the minibuffer or in the calendar
         (not (minibufferp))
         (not (> 120 (frame-width)))
         ;; (not (bound-and-true-p olivetti-mode))
         (not (derived-mode-p 'calendar-mode))
         ;; Show org-roam buffer iff the current buffer has a org-roam file
         (xor (org-roam-file-p) (eq 'visible (org-roam-buffer--visibility))))
    (org-roam-buffer-toggle)))
  (add-hook 'window-buffer-change-functions 'xyu/org-roam-buffer-show)

  ;; org-roam-capture
  (setq org-roam-capture-templates
        '(("e" "Newsletter" plain "%?"
           :target (file+head "newsletter/${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("b" "Books" plain (file "~/.doom.d/template/readinglog")
           :target (file+head "books/${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("d" "Diary" plain "%?"
           :target (file+datetree "daily/<%Y-%m>.org" day))
          ("n" "Note" plain "%?"
           :target (file+head "notes/${slug}.org"
                         "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("w" "Work" plain "%?"
           :target (file+head "work/${slug}.org"
                         "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("p" "people" plain (file "~/.doom.d/template/crm")
           :target (file+head "crm/${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("r" "reference" plain (file "~/.doom.d/template/reference")
           :target (file+head "ref/${citekey}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t)
          ("k" "PKM" plain "%?"
           :target (file+head "PKM/${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+MODIFIED: \n")
           :unnarrowed t))))

(after! org-roam
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))

  (cl-defmethod org-roam-node-directories ((node org-roam-node))
    (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
        (format "(%s)" (car (split-string dirs "/")))
      ""))

  (cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
    (let* ((count (caar (org-roam-db-query
                         [:select (funcall count source)
                                  :from links
                                  :where (= dest $s1)
                                  :and (= type "id")]
                         (org-roam-node-id node)))))
      (format "[%d]" count)))

  (cl-defmethod org-roam-node-doom-filetitle ((node org-roam-node))
    "Return the value of \"#+title:\" (if any) from file that NODE resides in.
   If there's no file-level title in the file, return empty string."
    (or (if (= (org-roam-node-level node) 0)
            (org-roam-node-title node)
          (org-roam-get-keyword "TITLE" (org-roam-node-file node)))
        ""))

  (cl-defmethod org-roam-node-doom-hierarchy ((node org-roam-node))
    "Return hierarchy for NODE, constructed of its file title, OLP and direct title.
   If some elements are missing, they will be stripped out."
    (let ((title     (org-roam-node-title node))
          (olp       (org-roam-node-olp   node))
          (level     (org-roam-node-level node))
          (filetitle (org-roam-node-doom-filetitle node))
          (separator (propertize " > " 'face 'shadow)))
      (cl-case level
        ;; node is a top-level file
        (0 filetitle)
        ;; node is a level 1 heading
        (1 (concat (propertize filetitle 'face '(shadow italic))
                   separator title))
        ;; node is a heading with an arbitrary outline path
        (t (concat (propertize filetitle 'face '(shadow italic))
                   separator (propertize (string-join olp " > ") 'face '(shadow italic))
                   separator title)))))

  (setq org-roam-node-display-template (concat "${type:8} ${backlinkscount:3} ${doom-hierarchy:*}" (propertize "${tags:20}" 'face 'org-tag) " ")))

(use-package! consult-org-roam)
(use-package! consult-notes)

;; transclusion
(use-package! org-transclusion)

;; https://org-roam.discourse.group/t/opening-url-in-roam-refs-field/2564/4?u=jousimies
(defun xyu/open-node-roam-ref-url ()
  "Open the URL in this node's ROAM_REFS property, if one exists."
  (interactive)
  (when-let ((ref-url (org-entry-get-with-inheritance "ROAM_REFS")))
    (browse-url ref-url)))

;; Get reading list from books directory for org-clock report.
;; The org-clock report scope can be a function.
(defun xyu/reading-list ()
  "Get reading list."
  (let (reading-list)
    (append reading-list
            (file-expand-wildcards (expand-file-name "~/Org-Notes/Roam/books/*.org")))))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(defun +org-insert-file-link ()
  "Insert a file link.  At the prompt, enter the filename."
  (interactive)
  (insert (format "[[%s]]" (org-link-complete-file))))
;;
(map! :after org
      :map org-mode-map
      :localleader
      "l f" #'+org-insert-file-link)

(use-package! calibredb
  :defer t
  :init
  (setq! calibredb-root-dir "~/Sync/Library/calibre"
         calibredb-db-dir '((expand-file-name "metadata.db" calibredb-root-dir))
         calibredb-library-alist '(("~/Sync/Library/calibre")
                                   ("~/library/papers"))
         calibredb-format-all-the-icons t)
  :config
  (map! :map calibredb-show-mode-map
        "?" #'calibredb-entry-dispatch
        "o" #'calibredb-find-file
        "O" #'calibredb-find-file-other-frame
        "V" #'calibredb-open-file-with-default-tool
        "s" #'calibredb-set-metadata-dispatch
        "e" #'calibredb-export-dispatch
        "q" #'calibredb-entry-quit
        "y" #'calibredb-yank-dispatch
        "." #'calibredb-open-dired
        [tab] #'calibredb-toggle-view-at-point
        "M-t" #'calibredb-set-metadata--tags
        "M-a" #'calibredb-set-metadata--author_sort
        "M-A" #'calibredb-set-metadata--authors
        "M-T" #'calibredb-set-metadata--title
        "M-c" #'calibredb-set-metadata--comments)
  (map! :map calibredb-search-mode-map
        [mouse-3] #'calibredb-search-mouse
        "RET" #'calibredb-find-file
        "?" #'calibredb-dispatch
        "a" #'calibredb-add
        "A" #'calibredb-add-dir
        "c" #'calibredb-clone
        "d" #'calibredb-remove
        "D" #'calibredb-remove-marked-items
        "j" #'calibredb-next-entry
        "k" #'calibredb-previous-entry
        "l" #'calibredb-virtual-library-list
        "L" #'calibredb-library-list
        "n" #'calibredb-virtual-library-next
        "N" #'calibredb-library-next
        "p" #'calibredb-virtual-library-previous
        "P" #'calibredb-library-previous
        "s" #'calibredb-set-metadata-dispatch
        "S" #'calibredb-switch-library
        "o" #'calibredb-find-file
        "O" #'calibredb-find-file-other-frame
        "v" #'calibredb-view
        "V" #'calibredb-open-file-with-default-tool
        "." #'calibredb-open-dired
        "y" #'calibredb-yank-dispatch
        "b" #'calibredb-catalog-bib-dispatch
        "e" #'calibredb-export-dispatch
        "r" #'calibredb-search-refresh-and-clear-filter
        "R" #'calibredb-search-clear-filter
        "q" #'calibredb-search-quit
        "m" #'calibredb-mark-and-forward
        "f" #'calibredb-toggle-favorite-at-point
        "x" #'calibredb-toggle-archive-at-point
        "h" #'calibredb-toggle-highlight-at-point
        "u" #'calibredb-unmark-and-forward
        "i" #'calibredb-edit-annotation
        "DEL" #'calibredb-unmark-and-backward
        [backtab] #'calibredb-toggle-view
        [tab] #'calibredb-toggle-view-at-point
        "M-n" #'calibredb-show-next-entry
        "M-p" #'calibredb-show-previous-entry
        "/" #'calibredb-search-live-filter
        "M-t" #'calibredb-set-metadata--tags
        "M-a" #'calibredb-set-metadata--author_sort
        "M-A" #'calibredb-set-metadata--authors
        "M-T" #'calibredb-set-metadata--title
        "M-c" #'calibredb-set-metadata--comments))

;;(defvar xyu/biblio-libraries-list (list (expand-file-name "~/Org-Notes/Library/myReferences.bib")))
;; bibtex-completion
(after! bibtex-completion
  ;;(setq bibtex-completion-bibliography '(("~/Org-Notes/Library/zotero.bib")
  ;;                                       ("~/Sync/Library/calibre/catalog.bib")))
  (setq bibtex-completion-bibliography '("~/Org-Notes/Library/zotero.bib"))
  (setq bibtex-completion-notes-path "~/Org-Notes/Roam/reading")
  (setq bibtex-completion-library-path "~/Zotero")
  (setq bibtex-completion-pdf-field "File")
  (setq bibtex-completion-additional-search-fields '(keywords journal booktitle))
  (setq bibtex-completion-pdf-symbol "P")
  (setq bibtex-completion-notes-symbol "N")
  (setq bibtex-completion-display-formats '((article . "${=has-pdf=:1} ${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
                                            (inbook . "${=has-pdf=:1} ${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
                                            (incollection . "${=has-pdf=:1} ${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
                                            (inproceedings . "${=has-pdf=:1} ${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
                                            (t . "${=has-pdf=:1} ${=has-note=:1} ${year:4} ${author:36} ${title:*}"))))
;; Citar
(after! citar
  ;; (setq citar-bibliography org-cite-global-bibliography)
  (setq citar-bibliography '("~/Org-Notes/Library/zotero.bib"))
  (setq citar-notes-paths "~/Org-Notes/Roam/reading")
  ;;(setq citar-library-paths "~/Zotero")
  ;;(setq citar-library-file-extensions '("pdf" "jpg" "epub"))
  (setq citar-at-point-function 'embark-act)
  (setq citar-templates '((main . "${author editor:30} ${date year issued:4} ${title:48}")
                          (suffix . "${=key= id:15} ${=type=:12} ${tags keywords:*}")
                          (preview . "${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
                          (note . "${title}")))
  (setq citar-symbol-separator "  ")
  (setq citar-library-file-extensions (list "pdf" "jpg"))
  (setq citar-file-additional-files-separator "-")

  ;; https://blog.tecosaur.com/tmio/2021-07-31-citations.html
  (setq org-cite-global-bibliography citar-bibliography)
  (setq org-cite-insert-processor 'citar)
  (setq org-cite-follow-processor 'citar)
  (setq org-cite-activate-processor 'citar)

  (with-eval-after-load 'all-the-icons
    (setq citar-symbols
          `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
            (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
            (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " "))))

  (with-eval-after-load 'citar-org
    (define-key citar-org-citation-map (kbd "<return>") 'org-open-at-point)
    (define-key org-mode-map (kbd "C-c C-x @") 'citar-insert-citation)))

(after! citar-org-roam
  (with-eval-after-load 'org-roam
    ;; citar-org-roam
    (citar-org-roam-mode)
    (with-eval-after-load 'citar-org-roam
      (setq citar-org-roam-subdir "reading")
      (setq citar-org-roam-note-title-template "${title}"))

    ;; Temporarily work, wait citar-org-roam update to support capture with template.
 ;;   (defun xyu/citar-org-roam--create-capture-note (citekey entry)
 ;;     "Open or create org-roam node for CITEKEY and ENTRY."
 ;;     ;; adapted from https://jethrokuan.github.io/org-roam-guide/#orgc48eb0d
 ;;     (let ((title (citar-format--entry
 ;;                   citar-org-roam-note-title-template entry)))
 ;;       (org-roam-capture-
 ;;        :templates
 ;;        '(("r" "reading" plain (file "~/.doom.d/template/readinglog") :if-new ;; Change "%?" to a template file.
 ;;           (file+head
 ;;            "%(concat
 ;;                 (when citar-org-roam-subdir (concat citar-org-roam-subdir \"/\")) \"${title}-note.org\")"
 ;;            "#+title: ${title}\n")
 ;;           :immediate-finish t
 ;;           :unnarrowed t))
 ;;        :info (list :citekey citekey)
 ;;        :node (org-roam-node-create :title title)
 ;;        :props '(:finalize find-file))
 ;;       (org-roam-ref-add (concat "@" citekey))))
 ;;   (advice-add 'citar-org-roam--create-capture-note :override #'xyu/citar-org-roam--create-capture-note)
(defun citar-org-roam--create-capture-note (citekey entry)
      "Open or create org-roam node for CITEKEY and ENTRY."
      ;; adapted from https://jethrokuan.github.io/org-roam-guide/#orgc48eb0d
      (let ((title (citar-format--entry
                    citar-org-roam-note-title-template entry)))
        (org-roam-capture-
         :templates
         '(("r" "reference" plain (file "~/.doom.d/template/readinglog") :if-new
            (file+head "reading/${title}.org"
                       ":PROPERTIES:\n:ROAM_REFS: [cite:@${citekey}]\n:END:\n#+title: ${title}\n")
            :unnarrowed t))
      :info (list :citekey citekey)
      :node (org-roam-node-create :title title)
      :props '(:finalize find-file))))

    (after! citar-embark
      (add-hook 'org-mode-hook 'citar-embark-mode))

    (with-eval-after-load 'org-roam
      (use-package! org-roam-bibtex)
      )))

;; Ebib
;; A replace of zotero, But I think zotero is better to use.
;; Only use ebib to filter reference in Emacs.
(after! ebib
  (setq ebib-index-mode-line nil)
  (setq ebib-entry-mode-line nil)

  (setq ebib-preload-bib-files bibtex-completion-bibliography)

  (setq ebib-keywords ("~/Org-Notes/Library/keywords.txt"))
  (setq ebib-notes-directory ("~/Org-Notes/Roam/reading"))
  (setq ebib-filters-default-file ("~/Org-Notes/Library/ebib-filters"))
  (setq ebib-reading-list-file ("~/Org-Notes/Library/reading_list.org"))

  (setq ebib-keywords-field-keep-sorted t)
  (setq ebib-keywords-file-save-on-exit 'always)

  (setq ebib-index-columns
        '(("Entry Key" 30 t) ("Note" 1 nil) ("Year" 6 t) ("Title" 50 t)))
  (setq ebib-file-associations '(("ps" . "gv"))))

;;(global-set-key (kbd "<f2>") 'ebib)

;; == Can do, but not useful.
;; use biblio to search bibtex.
;; 不怎么使用这个功能，Zotero 在这个方面更好使。
;;(require-package 'biblio)
;;(defun my/biblio-lookup-crossref ()
;;    (interactive)
;;  (biblio-lookup 'biblio-crossref-backend))
;;;; 常出错，不如使用网页版进行。
;;(when (maybe-require-package 'scihub)
;;  (setq scihub-download-directory "~/Downloads/")
;;  (setq scihub-open-after-download t))
;;
;;;; company-auctex
(use-package! company-auctex)
(add-hook 'company-mode-hook 'company-auctex-init)

;; (defun company-bibtex-completion-candidates ()
;;   (let ((bibtex-completion-bibliography
;;          (or (bibtex-completion-find-local-bibliography)
;;              bibtex-completion-bibliography)))
;;     (mapcar (lambda (x) (propertize (cdr (assoc "=key=" (cdr x)))
;;                                     'bibtex-completion-annotation
;;                                     (cdr (assoc "title" (cdr x)))))
;;             (bibtex-completion-candidates))))

;; (defun company-bibtex-completion (command &optional arg &rest ignored)
;;   "bibtex-completion backend."
;;   (interactive (list 'interactive))
;;   (cl-case command
;;     (interactive (company-begin-backend 'company-bibtex-completion))
;;     (prefix (let ((prefixes
;;                    (cond ((derived-mode-p 'latex-mode)
;;                           (company-auctex-prefix "\\\\cite[^[{]*\\(?:\\[[^]]*\\]\\)?{\\([^}]*\\)\\="))
;;                          ((and (derived-mode-p 'org-mode)
;;                                (not (org-in-src-block-p))
;;                                (looking-back "cite:\\([^}]*\\)"))
;;                           (match-string-no-properties 1))
;;                          (t nil))))
;;               (if prefixes
;;                   (last (split-string prefixes "," t))
;;                 nil)))
;;     (candidates (all-completions arg (company-bibtex-completion-candidates)))
;;     (annotation (get-text-property 0 'bibtex-completion-annotation arg))))

;; (add-to-list 'company-backends #'company-bibtex-completion)


;;(provide 'init-bibtex)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-bibtex.el ends here

(add-hook 'doc-view-mode-hook 'pdf-tools-install)

;;(when (maybe-require-package 'pdf-tools)

  (after! pdf-tools
    (setq-default pdf-view-display-size 'fit-width))

  (add-hook 'pdf-tools-enabled-hook
            #'(lambda ()
                (if (string-equal "dark" (frame-parameter nil 'background-mode))
                    (pdf-view-themed-minor-mode 1))))

  (setq pdf-view-use-unicode-ligther nil)
  (setq pdf-view-use-scaling t)
  (setq pdf-view-use-imagemagick nil)
  (setq pdf-annot-activate-created-annotations nil)

  (defun xyu/get-file-name ()
    "Copy pdf file name."
    (interactive)
    (kill-new (file-name-base (buffer-file-name)))
    (message "Copied %s" (file-name-base (buffer-file-name))))

  (after! pdf-view
  ;;   (define-key pdf-view-mode-map (kbd "w") 'xyu/get-file-name)
  ;;   (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  ;;   (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  ;;   (define-key pdf-view-mode-map (kbd "d") 'pdf-annot-delete)
  ;;   (define-key pdf-view-mode-map (kbd "q") 'kill-this-buffer)
  ;;   (define-key pdf-view-mode-map (kbd "y") 'pdf-view-kill-ring-save)
  ;;   (define-key pdf-view-mode-map (kbd "G") 'pdf-view-goto-page))
    (define-key pdf-view-mode-map [remap pdf-misc-print-document] 'mrb/pdf-misc-print-pages))

  (after! pdf-outline
    (define-key pdf-outline-buffer-mode-map (kbd "<RET>") 'pdf-outline-follow-link-and-quit))

  (after! pdf-annot
    (define-key pdf-annot-edit-contents-minor-mode-map (kbd "<return>") 'pdf-annot-edit-contents-commit)
    (define-key pdf-annot-edit-contents-minor-mode-map (kbd "<S-return>") 'newline))

  (after! pdf-cache
    (define-pdf-cache-function pagelabels))

  (after! pdf-misc
    (setq pdf-misc-print-program-executable "/usr/bin/lp")

    (defun mrb/pdf-misc-print-pages(filename pages &optional interactive-p)
      "Wrapper for `pdf-misc-print-document` to add page selection support."
      (interactive (list (pdf-view-buffer-file-name)
                         (read-string "Page range (empty for all pages): "
                                      (number-to-string (pdf-view-current-page)))
                         t) pdf-view-mode)
      (let ((pdf-misc-print-program-args
             (if (not (string-blank-p pages))
       (cons (concat "-P " pages) pdf-misc-print-program-args)
       pdf-misc-print-program-args)))
        (pdf-misc-print-document filename))))

(defun xyu/pdf-extract-highlight ()
  "Extract highlight to plain text."
  (interactive)
  (let* ((pdf-filename (buffer-name))
         (txt-filename (make-temp-name "/tmp/tabula-"))
         (buffer (generate-new-buffer
                  (generate-new-buffer-name (format "*pdftohighlight<%s>*"
                                                    pdf-filename)))))
    (shell-command (format "python3 ~/pdfannots/pdfannots.py \"%s\" -o \"%s\""
                           pdf-filename txt-filename) nil)
    (switch-to-buffer buffer)
    (insert-file-contents txt-filename)
    (delete-file txt-filename)))

;;(when (maybe-require-package 'nov)
;;  (setq nov-unzip-program (executable-find "bsdtar")
;;        nov-unzip-args '("-xC" directory "-f" filename))
;;  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;;另一套配置，来自：https://emacs-china.org/t/doomemacs-eaf/23155/10
;;;(setq! bibtex-completion-bibliography '("~/Documents/org/roam/biblibrary/references.bib"))
;;
;;;j(setq! citar-bibliography '("~/Documents/org/roam/biblibrary/references.bib"))
;;
;;;(setq! bibtex-completion-library-path '("~/Documents/org/roam/biblibrary/")
;;;       bibtex-completion-notes-path "~/Documents/org/roam/")
;;
;;;(setq! citar-library-paths '("~/Documents/org/roam/biblibrary/")
;;;       citar-notes-paths '("~/Documents/org/roam/"))
;;
;;
;;(after! pdf-view
;;  ;; open pdfs scaled to fit page
;;  (setq-default pdf-view-display-size 'fit-width)
;;  (add-hook! 'pdf-view-mode-hook (evil-colemak-basics-mode -1))
;;  ;; automatically annotate highlights
;;  (setq pdf-annot-activate-created-annotations t
;;        pdf-view-resize-factor 1.1)
;;   ;; faster motion
;; (map!
;;   :map pdf-view-mode-map
;;   :n "g g"          #'pdf-view-first-page
;;   :n "G"            #'pdf-view-last-page
;;   :n "N"            #'pdf-view-next-page-command
;;   :n "E"            #'pdf-view-previous-page-command
;;   :n "e"            #'evil-collection-pdf-view-previous-line-or-previous-page
;;   :n "n"            #'evil-collection-pdf-view-next-line-or-next-page
;;   :localleader
;;   (:prefix "o"
;;    (:prefix "n"
;;     :desc "Insert" "i" 'org-noter-insert-note
;;     ))
;; ))
;;
;;;;   (after! PACKAGE
;;;;     (setq x y))
;;
;;(after! org-ref
;;        (setq
;;         bibtex-completion-notes-path "~/Documents/org/roam/"
;;         bibtex-completion-bibliography "~/Documents/org/roam/biblibrary/references.bib"
;;         bibtex-completion-pdf-field "file"
;;         bibtex-completion-notes-template-multiple-files
;;         (concat
;;          "#+TITLE: ${title}\n"
;;          "#+ROAM_KEY: cite:${=key=}\n"
;;          "* TODO Notes\n"
;;          ":PROPERTIES:\n"
;;          ":Custom_ID: ${=key=}\n"
;;          ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
;;          ":AUTHOR: ${author-abbrev}\n"
;;          ":JOURNAL: ${journaltitle}\n"
;;          ":DATE: ${date}\n"
;;          ":YEAR: ${year}\n"
;;          ":DOI: ${doi}\n"
;;          ":URL: ${url}\n"
;;          ":END:\n\n"
;;          )
;;         ))
;;
;;(use-package! org-ref
;;    :config
;;    (setq
;;         org-ref-completion-library 'org-ref-ivy-cite
;;         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
;;         org-ref-default-bibliography (list "~/Documents/org/roam/biblibrary/references.bib")
;;         org-ref-bibliography-notes "~/Documents/org/roam/bibnotes.org"
;;         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
;;         org-ref-notes-directory "~/Documents/org/roam/"
;;         org-ref-notes-function 'orb-edit-notes
;;    ))
;;
;; (use-package! org-roam-bibtex
;;  :after (org-roam)
;;  :hook (org-roam-mode . org-roam-bibtex-mode)
;;  :config
;;  (setq org-roam-bibtex-preformat-keywords
;;   '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
;;  (setq orb-templates
;;        '(("r" "ref" plain (function org-roam-capture--get-point)
;;           ""
;;           :file-name "${slug}"
;;           :head "#+TITLE: ${=key=}: ${title}\n#+ROAM_KEY: ${ref}
;;
;;- tags ::
;;- keywords :: ${keywords}
;;
;;\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n  :NOTER_PAGE: \n  :END:\n\n"
;;
;;           :unnarrowed t))))
;;
;;(after! helm
;;  ;; I want backspace to go up a level, like ivy
;;  (add-hook! 'helm-find-files-after-init-hook
;;    (map! :map helm-find-files-map
;;          "<DEL>" #'helm-find-files-up-one-level)))
;;
;;;; Actually start using templates
;;(after! org-capture
;;  ;; Firefox
;;  (add-to-list 'org-capture-templates
;;               '("P" "Protocol" entry
;;                 (file+headline +org-capture-notes-file "Inbox")
;;                 "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?"
;;                 :prepend t
;;                 :kill-buffer t))
;;  (add-to-list 'org-capture-templates
;;               '("L" "Protocol Link" entry
;;                 (file+headline +org-capture-notes-file "Inbox")
;;                 "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n"
;;                 :prepend t
;;                 :kill-buffer t))
;;  ;; Misc
;;  (add-to-list 'org-capture-templates
;;         '("a"               ; key
;;           "Article"         ; name
;;           entry             ; type
;;           (file+headline +org-capture-notes-file "Article")  ; target
;;           "* %^{Title} %(org-set-tags)  :article: \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\nBrief description:\n%?"  ; template
;;           :prepend t        ; properties
;;           :empty-lines 1    ; properties
;;           :created t        ; properties
;;           ))
;;)



;;(use-package! org-protocol-capture-html
;;  :after org-protocol
;;  :config
;;  (add-to-list 'org-capture-templates
;;               '("w"
;;                 "Web site"
;;                 entry
;;                 (file+headline +org-capture-notes-file "Website")  ; target
;;                 "* %a :website:\n\n%U %?\n\n%:initial")
;;               )
;;  )

;;(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
;;
;;(require 'eaf)
;;
;; (require 'eaf-markdown-previewer)
;;;; (require 'eaf-rss-reader)
;; (require 'eaf-pdf-viewer)
;;;; (require 'eaf-image-viewer)
;; (require 'eaf-browser)
;; (require 'eaf-org-previewer)
;;;; (require 'eaf-mindmap)
;;;; (require 'eaf-org)
;; (defun eaf-org-open-file (file &optional link)
;;  "An wrapper function on `eaf-open'."
;;  (eaf-open file))
;;;;请使用 M-x eaf-org-export-to-pdf-and-open
;;;; use `emacs-application-framework' to open PDF file: link
;; (add-to-list 'org-file-apps '("\\.pdf\\'" . eaf-org-open-file))
;;
;; (require 'eaf-evil)
;;;; eaf会把C-SPC当成evil的leader-key，在你加载'eaf-evil之后使用eaf时就需要在eaf中键入C-SPC使用evil leader下的键。
;;;; 我们只需要将这个键设置为 SPC或你自己的evil-leader-key即可
;; (setq eaf-evil-leader-key "SPC")
;;
;;;;使用eaf查看latex输出的pdf文件
;; (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
;; (add-to-list 'TeX-view-program-list '("eaf" eaf-pdf-synctex-forward-view))
;; (add-to-list 'TeX-view-program-selection '(output-pdf "eaf"))

;;如果不想用深色背景
;;(setq eaf-pdf-dark-mode nil)

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
